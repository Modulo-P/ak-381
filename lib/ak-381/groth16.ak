use aiken.{G1Element}
// ,MillerLoopResult
use aiken/builtin.{
  bls12_381_final_verify, bls12_381_g1_add, bls12_381_g1_compress,
  bls12_381_g1_scalar_mul, bls12_381_g1_uncompress, bls12_381_g2_uncompress,
  bls12_381_miller_loop, bls12_381_mul_miller_loop_result,
}
use aiken/list.{head, map, map2, reduce, tail}

pub type SnarkVerificationKey {
  nPublic: Int,
  // G1Element
  vkAlpha: ByteArray,
  // G2Element
  vkBeta: ByteArray,
  // G2Element
  vkGamma: ByteArray,
  // G2Element
  vkDelta: ByteArray,
  // List<G2Element>
  vkAlphaBeta: List<ByteArray>,
  // List<G1Element>
  vkIC: List<ByteArray>,
}

//
pub type Proof {
  // G1Element 
  piA: ByteArray,
  // G2Element
  piB: ByteArray,
  // G1Element
  piC: ByteArray,
}

pub fn pairing(g1: ByteArray, g2: ByteArray) {
  bls12_381_miller_loop(
    bls12_381_g1_uncompress(g1),
    bls12_381_g2_uncompress(g2),
  )
}

pub fn groth_verify(
  vk: SnarkVerificationKey,
  proof: Proof,
  public: List<Int>,
) -> Bool {
  // let n = vk.nPublic

  let eAB = pairing(proof.piA, proof.piB)
  let eAlphaBeta = pairing(vk.vkAlpha, vk.vkBeta)

  expect Some(vk_ic_head) = head(vk.vkIC)
  expect Some(vk_ic_tail) = tail(vk.vkIC)
  let vkICHead: G1Element = bls12_381_g1_uncompress(vk_ic_head)
  let vkICTail: List<G1Element> =
    map(vk_ic_tail, fn(n) { bls12_381_g1_uncompress(n) })
  let derived_vkIC = map2(public, vkICTail, bls12_381_g1_scalar_mul)
  let vkI =
    reduce(derived_vkIC, vkICHead, bls12_381_g1_add) |> bls12_381_g1_compress()
  let eIGamma = pairing(vkI, vk.vkGamma)
  let eCDelta = pairing(proof.piC, vk.vkDelta)

  let mlr1 = bls12_381_mul_miller_loop_result(eAlphaBeta, eIGamma)
  let mlr2 = bls12_381_mul_miller_loop_result(mlr1, eCDelta)
  bls12_381_final_verify(eAB, mlr2)
}

// Test (3 Factorial problem)

test groth_verify_1() {
  //  Template of VK
  let vk: SnarkVerificationKey =
    SnarkVerificationKey {
      nPublic: 2,
      vkAlpha: #"8e3d9e248feda194cb6fa0a3b64fd2a380cb5e94836bf8148bf97ebcbb5819d9a78f63102f0293c104bcbb2f810d8eb4",
      vkBeta: #"8cd68a7186a908212680a0234d8210c20328f8fb3ce1d69c9aec9330a5802d6cfaf6d7cf3176133221c19188590cb4141874ea7bbfcb9872931e115d882c46b90c3dcbcee10062d1c9b9b0a691d7bec7d2735f06495c7f71dea210e55b2782df",
      vkGamma: #"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      vkDelta: #"938231fcec443fbdeb1079ff126b8f69bd8579ffe82d39923214d4345395beee60200288fa20c97ae50f3212131b6f8802af2f9f515c65af6a9a6c294c738590104376a0af44731d6699db6a286608774243f7d1dddc4605eb340e65e15060a5",
      vkAlphaBeta: [
        #"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
      ],
      vkIC: [
        #"b5813c90d3455acb8608fdf66e8601f24ef048f3fdf9384862d77c72cb5cddfde2b307976b1b0319c42ba985f94be60a",
        #"a41a0e6370c054be0f9acce08e97f6d5702d9daa9e9a934e8a377f553593baa1c58062adc73d63558653422d54d6f50c",
        #"8e02a87c519c3145f984d25fdf769f74fbc36626c385d4554fb4bc1d7a12cbf669d40f257023b8b3c9a31e631aa8f981",
      ],
    }

  //  Template of Proof
  let pk: Proof =
    Proof {
      piA: #"b28cb29bc282be68df977b35eb9d8e98b3a0a3fc7c372990bddc50419ca86693e491755338fed4fb42231a7c081252ce",
      piB: #"b9215e5bc481ba6552384c89c23d45bd650b69462868248bfbb83aee7060579404dba41c781dec7c2bec5fccec06842e0e66ad6d86c7c76c468a32c9c0080eea0219d0953b44b1c4f5605afb1e5a3193264ff730222e94f55207628235f3b423",
      piC: #"886a574105c0da95915c36025637e5b80c7c00c4a264b529b465c273ade3e38f15dc7840498a1aefb44a24a0070a2ff6",
    }
  // Template of public values
  let public_values: List<Int> =
    [562, 3]

  groth_verify(vk, pk, public_values)
}
