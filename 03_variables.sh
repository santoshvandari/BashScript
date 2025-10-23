#!/bin/bash

# Defining Variables
name="Santosh Bhandari" #String
age=25 #integer
language="Shell Scripting" #String

# Some Other Types of Variables 
float_value=2.3023  # Float Value
bool_value=True  # Boolean Value

# String in Multiple Line
message="Hi Dev, Currently I am Learning Shell Scripting. 
This is mostly use for creating the script and setup that 
script in cornjobs."

echo "Hi I am $name. I am $age years old and learning $language"
echo -e "Float Value = $float_value.\nBoolean Value = $bool_value."

# To Print the message in single line
echo $message

# To Print The message As it is
echo "$message"

# Const Variables
readonly GIT_USERNAME="santoshvandari"

# Storing variable values 
COMPUTER_HOSTNAME=$(hostname)
echo $COMPUTER_HOSTNAME