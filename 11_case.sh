#!/bin/bash

# Menu Options
echo "Options
a) Addition
b) Difference
c) Multiplication
d) Division
random) Modulas
Enter Your Choice(a,b,c,d): "

# User Choice
read choice

read -p "Enter first Number: " num1
read -p "Enter Second Number: " num2

# Case
case $choice in
    a) echo "Addition: $(($num1+$num2))";;
    b) echo "Subtraction: $(($num1-$num2))";;
    c) echo "Multiplicatiion: $(($num1*$num2))";;
    d) echo "Division: $(($num1/$num2))";;
    random) echo "Modulas : $(($num1%$num2))";;
    *) echo "Invalid Option Selection"


esac






















