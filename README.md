# AK-381: A SNARK verification library using bls12-381

This Aiken library implements utilities to verificate Zero-Knowledge proof
following the Groth16 protocol. The main feature is a zk-SNARK verification
function, along with utilities to create proofs and interoperate with the Plutus
VM. The library is tailored to use with the Circom language and the SnarkJs
module.

The statement...

I can prove to you "x" without to reveal "x".

Is now possible in its endless variations in this next PlutusV3 hardfork.

## About zk-SNARKs

In short, a zk-SNARK follows a three step process:

1. Setup: A preprocessing of the circuit (representation of the statement or
   algorith that you want to prove) that results in the proverk-ey and
   verification-key
2. Proof: The creation of a proof of the statement.
3. Verification: The verification of the statement given the proof (and not the
   data itself).

## The 3 prime factorization example

In order to make this library ilustrative, we use a circuit that proofs that we
know the multiplication of three big prime numbers to a verifier. Although in
this example we use small prime numbers, to deduce the prime factors from the
result is usually an hard and challenging computation problem. In this case for
a given number we show just one factor and we proof that we know the other two
without revealing them.

## Requisites

In order to use this library you must have circom and Snarkjs. You can get both
installed following this part of the
[circom documentation](https://docs.circom.io/getting-started/installation/)

## Structure folder

- Circuits: The folder where you put your circom circuits.
- 3_fac: The output of the circuit that we use as example.
- conversion: The javascript module where you can convert the proof and
  verification-key given by circom into the serialization that Plutus need.

## Import the module into your Aiken project

To import the module you must execute the following command with the
corresponding version. At the momment the version is `v0.1`.

```bash
aiken packages add modulo-p/ak-381 --version v0.1
```

## The Groth16 process.

Groth16 is a zk-SNARK protocol that is characterized by its lighter proof and
efficient verification. This library includes a bash script `.groth16` that
conduct you to the full process of setup, proving and verification. Regarding
the setup that in the case of Groth16 requires a multi-party computation so it
will ask you various randoms contributions to securely create the prover-key and
verificatio-key. Make sure to take a look in the script to know more.

Before executing the script you have to set some things:

- Set your circuit in the `/circuits`folder.
- Set the `input.json` file (see below creating the witness).
- Set the `public.json`file (see below creating the witness).

Once you circuits and other files are ready, you can start the Groth16 protocol
from setup, to proof and verification using:

```bash
./groth16
```

The script it's going to ask you about the circuit that you want to use. It is
going to create you a folder with the name of the circuit which will storage all
the outputs of the process.

### Use with SnarkJs

Once you have completed the setup and created the `<circuit>_final.zkey`you can
create new proofs and verify them.

**Creating the witness**

We create set the inputs of our proof in the `input.json` file. In this case we
define the 3 factors (x1,x2 and x3) with these:

```JSON
{ "x1": 3, "x2": 11, "x3": 17 }
```

And then change the `public.json` with the product of the factors and x1:

```JSON
[
  "561",
  "3"
]
```

Then we take the wasm compilation of the circuit and the`input.json` file and
output the result in `witness.wtns`

```bash
snarkjs wc 3_fac_js/3_fac.wasm input.json witness.wtns
```

**Creating the proof**

With the witness ready we can compute the proof.

```bash
narkjs g16p 3_fac_final.zkey witness.wtns proof.json public.json
```

**Verifying the proof**

```bash
snarkjs g16v verification_key.json public3.json proof3.json
```

And should output the following:

```bash
[INFO]  snarkJS: OK!
```

### Serialization of circom files.

In order to make the circom files interoperable with the Plutus VM, it is necessary to serialize the proof and verification key generated by circom. To serialize the circom files you can run the following:

```bash
#It will take as arg the folder of circom files, in our case is 3_fac.
$ ./convert.sh 3_fac
```

This will output the serialized proof and vk in its uncompressed form. It is important to point that the Plutus VM can operate uncompressed values, but will not let you store the uncompressed values as PlutusData. To store them as PlutusData you must do it in its compressed form, though the Aiken compiler can do the transformation under the hood for you.

Capabilities to convert values in its compressed form will be incorporated in the future.

