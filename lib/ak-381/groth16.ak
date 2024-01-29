use aiken/builtin.{bls12_381_final_verify, bls12_381_miller_loop}

type VerificationKey {
  nPublic: Int,
  vkAlpha: List<Int>,
  vkBeta: List<List<Int>>,
  vkGamma: List<List<Int>>,
  vkDelta: List<List<Int>>,
  vkAlphaBeta: List<List<List<Int>>>,
  vkIC: List<List<Int>>,
}

type Proof {
  piA: List<Int>,
  piB: List<List<Int>>,
  piC: List<Int>,
}

pub fn pairing(alfa: G1, beta: G2) -> Bool {
  todo
}

pub fn groth_verify(vk: VerificationKey, proof: Proof) -> Bool {
  todo
}
