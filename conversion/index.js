const fs = require("fs");

const proof = JSON.parse(fs.readFileSync("proof.json", "utf-8"));
const verificationKey = JSON.parse(fs.readFileSync("verification_key.json", "utf-8"));

console.log("Proof", JSON.stringify(proof));

function uncompressedFq(number) {
  const buffer = Buffer.alloc(48);
  buffer.write(BigInt(number).toString(16), 0, 48, "hex");
  return buffer.toString("hex");
}

function uncompressedG1(point) {
  const x = uncompressedFq(point[0]);
  const y = uncompressedFq(point[1]);
  return x + y;
}

function uncompressedG2(point) {
  const x = uncompressedFq(point[0][0]) + uncompressedFq(point[0][1]);
  const y = uncompressedFq(point[1][0]) + uncompressedFq(point[1][1]);
  return x + y;
}

function convertProofToUncompressed(proof) {

  const uncompressedProof = {
    "pi_a": uncompressedG1(proof.pi_a),
    "pi_b": uncompressedG2(proof.pi_b),
    "pi_c": uncompressedG1(proof.pi_c),
  }

  return uncompressedProof;
}


function convertVerificationKeyToUncompressed(verificationKey) {
  const uncompressedVerificationKey = {
    "vk_alpha_1": uncompressedG1(verificationKey.vk_alpha_1),
    "vk_beta_2": uncompressedG2(verificationKey.vk_beta_2),
    "vk_gamma_2": uncompressedG2(verificationKey.vk_gamma_2),
    "vk_delta_2": uncompressedG2(verificationKey.vk_delta_2),
    "IC": verificationKey.IC.map((item) => uncompressedG1(item)),
  }

  return uncompressedVerificationKey;
}

console.log("Uncompressed proof", JSON.stringify(convertProofToUncompressed(proof)));

console.log("\n\nUncompressed verification key", JSON.stringify(convertVerificationKeyToUncompressed(verificationKey)));

