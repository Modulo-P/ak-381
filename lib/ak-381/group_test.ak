use aiken/builtin.{
  bls12_381_g1_add
}
// {
//   bls12_381_final_verify, bls12_381_g1_add, bls12_381_g1_scalar_mul,
//   bls12_381_g1_uncompress, bls12_381_g2_uncompress, bls12_381_miller_loop,
//   bls12_381_mul_miller_loop_result,
// }

test group_add() {
  let g1: G1Element = (#"17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb", #"08b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1")

  let g1bis = bls12_381_g1_add(g1, g1)

  True
}
