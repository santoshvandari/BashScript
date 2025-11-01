#!/bin/bash
string="Hi Developers, How are you?"

echo "Upper Case ----- ${string^^}"
echo "Lower Case ----- ${string,,}"

echo "Replace ------ ${string/Developers/Programmer}"

echo "Read String Developers ------ ${string:3:10}" # From index 3. It will read next 10 Characters



