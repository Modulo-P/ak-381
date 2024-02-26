# AK-381: A SNARK verification library using bls12-381

This Aiken library implements utilities to verificate Zero-Knowledge proof following the Groth16 protocol. The main feature is a Zero-Knowledge verification function. The library is tailored to use with the Circom language and/or the SnarkJs modules. 


### Requisites

In order to use this library you must have circom and Snarkjs. You can get both installed following this part of the [circom documentation](https://docs.circom.io/getting-started/installation/)

### Structure folder

* Circuits: The folder where you put your circom circuits.
* 3_fac: The output of the circuit that we use as example.


### Start Grot16 process

Once you circom file is set in your circuits folder, you can start the Groth16 protocol from setup, to proof and verification using: 

```bash
./groth16
```

And it's going to ask you about the circuit that you want to use. It is going to create you a folder with the name of the circuit which will storage all the outputs of the process.

### Use it with SnarkJs

Todo

### The 3 factorization example

Todo

### Verify the proof

Todo



