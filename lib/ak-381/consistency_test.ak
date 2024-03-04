use aiken/builtin.{
  bls12_381_g1_add, bls12_381_g1_uncompress, bls12_381_g1_equal
}
// {
//   bls12_381_final_verify, bls12_381_g1_add, bls12_381_g1_scalar_mul,
//   bls12_381_g1_uncompress, bls12_381_g2_uncompress, bls12_381_miller_loop,
//   bls12_381_mul_miller_loop_result,
// }

test group_add() {
  let g1c: ByteArray = #"97f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb"

  let g1: G1Element = bls12_381_g1_uncompress(g1c)

  let twice_g1 = bls12_381_g1_add(g1, g1)

  let our_twice_g1c: ByteArray = #"a572cbea904d67468808c8eb50a9450c9721db309128012543902d0ac358a62ae28f75bb8f1c7c42c39a8c5529bf0f4e"

  let our_twice_g1: G1Element = bls12_381_g1_uncompress(our_twice_g1c)

  bls12_381_g1_equal(twice_g1, our_twice_g1)
}
