# AK-381: A SNARK verification library using bls12-381

This Aiken library implements utilities to verificate Zero-Knowledge proof
following the Groth16 protocol. The main feature is a Zero-Knowledge
verification function. The library is tailored to use with the Circom language
and the SnarkJs module.

### The 3 prime factorization example

In order to make this library ilustrative, we use a circuit that proofs that we
know the multiplication of three big prime numbers to a verifier. Although in
this example we use small prime numbers, to deduce the prime factors from the
result is usually an hard and challenging computation problem. In this case for
a given number we show just one factor and we proof that we know the other two
without revealing them.

### Requisites

In order to use this library you must have circom and Snarkjs. You can get both
installed following this part of the
[circom documentation](https://docs.circom.io/getting-started/installation/)

### Structure folder

- Circuits: The folder where you put your circom circuits.
- 3_fac: The output of the circuit that we use as example.
- conversion: The javascript module where you can convert the proof and
  verification-key given by circom into the serialization that Plutus need.

### Start Grot16 process

Once you circom file is set in your circuits folder, you can start the Groth16
protocol from setup, to proof and verification using:

```bash
./groth16
```

This script it's going to ask you about the circuit that you want to use. It is
going to create you a folder with the name of the circuit which will storage all
the outputs of the process.

### Use it with SnarkJs

Once you have completed the setup and created the `<circuit>_final.zkey`you can
create new proof and verify them.

**Creating the witness**

We create set the inputs of our proof in the `input.json` file. In this case we
define the 3 factors (x1,x2 and x3) with these:

```JSON
{ "x1": 3, "x2": 11, "x3": 17 }
```

Then we take the wasm compilation of the circuit and the input and output the
result in `witness.wtns`

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

### The conversion

Todo
