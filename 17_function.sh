#!/bin/bash

# Non Paramaeterized Function
# welcome(){
#     echo "Welcome to Shell Scripting"
# }
# welcome


# Paramaeterized Function
welcome(){
    local name=$1
    local language=$2
    echo "Hey $name. Welcome to $language Programming"
}

# Function Calling
welcome san python
welcome adi js
welcome alex golang









