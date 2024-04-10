#!/bin/bash

# Step 1: Echo "Path of your file?"
echo "Folder of your circom files?"

# Step 2: Take the relative path of the file from stdin and stored it in a variable called PROOF_PATH.
read CIRCOM_FILES_PATH

# Step 3: cd conversion.
cd $CIRCOM_FILES_PATH || exit 1

# Step 4: Inside conversion mkdir output.
#mkdir -p conv_outputs

#node ../conversion/index.js "$CIRCOM_FILES_PATH" > conv_outputs/output.txt || exit 1 
node ../conversion/index.js "$CIRCOM_FILES_PATH" || exit 1 

echo "Conversion done!"



