#!/bin/bash



CIRCOM_FILES_PATH=$1

cd $CIRCOM_FILES_PATH || exit 1

#node ../conversion/index.js "$CIRCOM_FILES_PATH" > conv_outputs/output.txt || exit 1 
node ../conversion/index.js "$CIRCOM_FILES_PATH" || exit 1 

echo "Serialization done!"



