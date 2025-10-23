#!/bin/bash

# Key Value Pair Storing in Array

declare -A KeyValueArray
KeyValueArray=([name]="Santosh Bhandari" [city]=Jhapa [country]=Nepal [age]=25)

echo "My name is ${keyValueArray[name]}. I am from ${KeyValueArray[city]}, ${KeyValueArray[country]}."
