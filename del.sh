#! /bin/bash

c=2
while [ $c -le 5 ]
do
 rm test[$c].py
 echo "hi"
 ((c++))
done




