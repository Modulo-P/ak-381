use aiken.{G1Element, G2Element}
// ,MillerLoopResult
use aiken/builtin.{
  bls12_381_final_verify, bls12_381_g1_add, bls12_381_g1_scalar_mul,
  bls12_381_g1_uncompress, bls12_381_miller_loop,
  bls12_381_mul_miller_loop_result,
}
use aiken/list.{head, map2, reduce, tail}

pub type SnarkVerificationKey {
  nPublic: Int,
  vkAlpha: G1Element,
  vkBeta: G2Element,
  vkGamma: G2Element,
  vkDelta: G2Element,
  vkAlphaBeta: List<G2Element>,
  vkIC: List<G1Element>,
}

pub type Proof {
  piA: G1Element,
  piB: G2Element,
  piC: G1Element,
}

pub fn pairing(g1: G1Element, g2: G2Element) {
  bls12_381_miller_loop(g1, g2)
}

pub fn groth_verify(
  vk: SnarkVerificationKey,
  proof: Proof,
  public: List<Int>,
) -> Bool {
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

// Test (3 Factorial problem)

test groth_verify_1() {
  // Template of VK
  let vk: SnarkVerificationKey =
    SnarkVerificationKey {
      nPublic: 8,
      vkAlpha: #<Bls12_381, G1>"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb",
      vkBeta: #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      vkGamma: #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      vkDelta: #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      vkAlphaBeta: [
        #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      ],
      vkIC: [
        #<Bls12_381, G1>"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb",
      ],
    }

  // Template of Proof
  let pk: Proof =
    Proof {
      piA: #<Bls12_381, G1>"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb",
      piB: #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      piC: #<Bls12_381, G1>"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb",
    }
  // Template of public values
  let public_values: List<Int> =
    [562, 3]

  groth_verify(vk, pk, public_values)
}
