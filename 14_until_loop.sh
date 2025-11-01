#!/bin/bash

count=0

until [[ $count -gt 10 ]]
do 
    echo $count;
    let count++
done

