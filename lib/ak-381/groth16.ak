use aiken.{G1Element, G2Element}  // ,MillerLoopResult
use aiken/builtin.{bls12_381_final_verify, bls12_381_miller_loop, bls12_381_g1_scalar_mul, bls12_381_g1_add, bls12_381_mul_miller_loop_result}
use aiken/list.{head, map2, reduce, tail}

pub type VerificationKey {
  nPublic: Int,
  vkAlpha: G1Element,
  vkBeta: G2Element,
  vkGamma: G2Element,
  vkDelta: G2Element,
  vkAlphaBeta: List<G2Element>,
  vkIC: List<G1Element>
}

pub type Proof {
  piA: G1Element,
  piB: G2Element,
  piC: G1Element
}

pub fn pairing(g1: G1Element, g2: G2Element) {
    bls12_381_miller_loop(g1, g2)
}

pub fn groth_verify(vk: VerificationKey, proof: Proof, public: List<Int>) -> Bool {
   // let n = vk.nPublic

   let eAB = pairing(proof.piA, proof.piB)
   let eAlphaBeta = pairing(vk.vkAlpha, vk.vkBeta)

   expect Some(vkICHead) = head(vk.vkIC)
   expect Some(vkICTail) = tail(vk.vkIC)
   let derived_vkIC = map2(public, vkICTail, bls12_381_g1_scalar_mul)
   let vkI = reduce(derived_vkIC, vkICHead, bls12_381_g1_add)
   let eIGamma = pairing(vkI, vk.vkGamma)
   let eCDelta = pairing(proof.piC, vk.vkDelta)

   let mlr1 = bls12_381_mul_miller_loop_result(eAlphaBeta, eIGamma)
   let mlr2 = bls12_381_mul_miller_loop_result(mlr1, eCDelta)
   bls12_381_final_verify(eAB, mlr2)
}
