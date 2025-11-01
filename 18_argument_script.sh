#!/bin/bash




# echo "First Argument : $1"
# echo "Second Argument : $2"


totalArguments=$*
lengthOfArgs=$#

for args in ${totalArguments[*]}
do
    echo $args
done

if [[ lengthOfArgs -eq 0 ]]
then
    echo "No arguments Passed"
    exit 1

fi 


echo "All Arguments : ${totalArguments[*]}"
echo "Length of Arguments : $lengthOfArgs"


# To use it
bash script.sh 1 2 3 4 5 adi "Adi Sharma"
# bash script.sh <args>