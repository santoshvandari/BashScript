#!/bin/bash

array=(1 1.22 "Santosh Bhandari" santosh true)

# Fetching the First Element
echo "Value of first element : ${array[0]}"

# Reading all the values
echo "Values in array: ${array[*]}"

# Reading the Element from 3 to 5
echo "Values from 3-5: ${array[*]:3:2}" # this will fetch the array from 3 index and fetch 2 elements. It will fetch 3,4

# Length of Array
echo "Length of Array: ${#array[*]}"

# Updating the Existing Array with New One
array+=(new data)

# Printing the Updated Values
echo "Values in Array: ${array[*]}"