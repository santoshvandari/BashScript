#!/bin/bash

read -p "Enter Your Marks: " marks

if [[ $marks -ge 80 ]]
then
    echo "You Achieve Fist Divison"
elif [[ $marks -ge 70 ]]
then
    echo "You Achieve Second Divison"
elif [[ $marks -ge 60 ]]
then
    echo "You Achieve Third Division"
elif [[ $marks -ge 40 ]]
then
    echo "You Passed"
else
    echo "Sorry!! You failed"
fi