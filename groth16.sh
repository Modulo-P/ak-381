#!/bin/bash

read -p "What is the name of the circuit?: " CIRCUIT_NAME
CIRCUIT_PATH="./circuits/$CIRCUIT_NAME.circom"

OUTPUT_PATH="${1:-$CIRCUIT_NAME/}"

if [ ! -d "$OUTPUT_PATH" ]; then
    mkdir -p "$OUTPUT_PATH"
fi

echo "[Setup](1/22): Start a new powers of tau ceremony"
snarkjs powersoftau new bls12-381 15 ${OUTPUT_PATH}pot15_0000.ptau -v

echo "[Setup](2/22): Contribute to the ceremony"
snarkjs powersoftau contribute ${OUTPUT_PATH}pot15_0000.ptau ${OUTPUT_PATH}pot15_0001.ptau --name="First contribution" -v

echo "[Setup](3/22): Provide a second contribution"
snarkjs powersoftau contribute ${OUTPUT_PATH}pot15_0001.ptau ${OUTPUT_PATH}pot15_0002.ptau --name="Second contribution" -v 

echo "[Setup](4/22): Verify the protocol so far"
snarkjs powersoftau verify ${OUTPUT_PATH}pot15_0002.ptau

echo "[Setup](5/22): Apply a random beacon"
snarkjs powersoftau beacon ${OUTPUT_PATH}pot15_0002.ptau ${OUTPUT_PATH}pot15_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"

echo "[Setup](6/22): Prepare phase 2"
snarkjs powersoftau prepare phase2 ${OUTPUT_PATH}pot15_beacon.ptau ${OUTPUT_PATH}pot15_final.ptau -v

echo "[Setup](7/22): Verify the final ptau"
snarkjs powersoftau verify ${OUTPUT_PATH}pot15_final.ptau

echo "[Setup](8/22): Compile the circuit"
circom $CIRCUIT_PATH --r1cs --wasm --sym -p bls12381 -o ${OUTPUT_PATH}

echo "[Setup](9/22): View information about the circuit"
snarkjs r1cs info ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs

echo "[Setup](10/22): Print the constraints"
snarkjs r1cs print ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs ${OUTPUT_PATH}${CIRCUIT_NAME}.sym

echo "[Setup](11/22): Export r1cs to json"
snarkjs r1cs export json ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs.json

echo "[Setup](12/22): Generate witness"
node ${OUTPUT_PATH}${CIRCUIT_NAME}_js/generate_witness.js ${OUTPUT_PATH}${CIRCUIT_NAME}_js/mastermind.wasm mastermind.input.json  ${OUTPUT_PATH}witness.wtns

echo "[Setup](13/22): Check witness"
snarkjs wtns check ${OUTPUT_PATH}$CIRCUIT_NAME.r1cs  ${OUTPUT_PATH}witness.wtns

echo "[Setup](14/22): Setup"
snarkjs groth16 setup ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs ${OUTPUT_PATH}pot15_final.ptau ${OUTPUT_PATH}${CIRCUIT_NAME}_0000.zkey

echo "[Setup](15/22): Contribute to the phase 2 ceremony"
snarkjs zkey contribute ${OUTPUT_PATH}${CIRCUIT_NAME}_0000.zkey ${OUTPUT_PATH}${CIRCUIT_NAME}_0001.zkey --name="1st Contributor Name" -v

echo "[Setup](16/22): Provide a second contribution"
snarkjs zkey contribute ${OUTPUT_PATH}${CIRCUIT_NAME}_0001.zkey ${OUTPUT_PATH}${CIRCUIT_NAME}_0002.zkey --name="Second contribution Name" -v 

echo "[Setup](17/22): Verify the latest zkey"
snarkjs zkey verify ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs ${OUTPUT_PATH}pot15_final.ptau ${OUTPUT_PATH}${CIRCUIT_NAME}_0002.zkey

echo "[Setup](18/22): Apply a random beacon"
snarkjs zkey beacon ${OUTPUT_PATH}${CIRCUIT_NAME}_0002.zkey ${OUTPUT_PATH}${CIRCUIT_NAME}_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"

echo "[Setup](19/22): Verify the final zkey"
snarkjs zkey verify ${OUTPUT_PATH}${CIRCUIT_NAME}.r1cs ${OUTPUT_PATH}pot15_final.ptau ${OUTPUT_PATH}${CIRCUIT_NAME}_final.zkey

echo "[Setup](20/22): Export the verification key"
snarkjs zkey export verificationkey ${OUTPUT_PATH}${CIRCUIT_NAME}_final.zkey ${OUTPUT_PATH}verification_key.json

echo "[Proof](21/22): Create the proof"
snarkjs groth16 prove ${OUTPUT_PATH}${CIRCUIT_NAME}_final.zkey ${OUTPUT_PATH}witness.wtns ${OUTPUT_PATH}proof.json ${OUTPUT_PATH}public.json

echo "[Verification](21/22): Verify the proof"
snarkjs groth16 verify ${OUTPUT_PATH}verification_key.json ${OUTPUT_PATH}public.json ${OUTPUT_PATH}proof.json