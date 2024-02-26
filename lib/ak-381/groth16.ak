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

// test groth_verify_1() {
//   // Template of VK
//   let vk: SnarkVerificationKey =
//     SnarkVerificationKey {
//       nPublic: 2,
//       vkAlpha: #<Bls12_381, G1>"e3d9e248feda194cb6fa0a3b64fd2a380cb5e94836bf8148bf97ebcbb5819d9a78f63102f0293c104bcbb2f810d8eb00",
//       vkBeta: #<Bls12_381, G2>"1874ea7bbfcb9872931e115d882c46b90c3dcbcee10062d1c9b9b0a691d7bec7d2735f06495c7f71dea210e55b2782dfcd68a7186a908212680a0234d8210c20328f8fb3ce1d69c9aec9330a5802d6cfaf6d7cf3176133221c19188590cb4100",
//       vkGamma: #<Bls12_381, G2>"24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb0013e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e",
//       vkDelta: #<Bls12_381, G2>"2af2f9f515c65af6a9a6c294c738590104376a0af44731d6699db6a286608774243f7d1dddc4605eb340e65e15060a00138231fcec443fbdeb1079ff126b8f69bd8579ffe82d39923214d4345395beee60200288fa20c97ae50f3212131b6f88",
//       vkAlphaBeta: [
//         #<Bls12_381, G2>"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
//       ],
//       vkIC: [
//         #<Bls12_381, G1>"15813c90d3455acb8608fdf66e8601f24ef048f3fdf9384862d77c72cb5cddfde2b307976b1b0319c42ba985f94be60a",
//         #<Bls12_381, G1>"41a0e6370c054be0f9acce08e97f6d5702d9daa9e9a934e8a377f553593baa1c58062adc73d63558653422d54d6f5000",
//         #<Bls12_381, G1>"e02a87c519c3145f984d25fdf769f74fbc36626c385d4554fb4bc1d7a12cbf669d40f257023b8b3c9a31e631aa8f9800",
//       ],
//     }

//   // Template of Proof
//   let pk: Proof =
//     Proof {
//       piA: #<Bls12_381, G1>"128cb29bc282be68df977b35eb9d8e98b3a0a3fc7c372990bddc50419ca86693e491755338fed4fb42231a7c081252ce",
//       piB: #<Bls12_381, G2>"e66ad6d86c7c76c468a32c9c0080eea0219d0953b44b1c4f5605afb1e5a3193264ff730222e94f55207628235f3b420019215e5bc481ba6552384c89c23d45bd650b69462868248bfbb83aee7060579404dba41c781dec7c2bec5fccec06842e",
//       piC: #<Bls12_381, G1>"86a574105c0da95915c36025637e5b80c7c00c4a264b529b465c273ade3e38f15dc7840498a1aefb44a24a0070a2ff00",
//     }
//   // Template of public values
//   let public_values: List<Int> =
//     [562, 3]

//   groth_verify(vk, pk, public_values)
// }

test bls_point_construction() {
  let point_1 = #<Bls12_381, G1>"184bb665c37ff561a89ec2122dd343f20e0f4cbcaec84e3c3052ea81d1834e192c426074b02ed3dca4e7676ce4ce48ba"
  True
}