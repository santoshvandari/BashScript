#!/bin/bash

myArray=(1 2 3 4 array data file)

length=${#myArray[*]}

# for ((i=0;i<$length;i++))
# do
#     echo ${myArray[$i]}
# done


for data in ${myArray[*]}
do
    echo $data
done