#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

targets_list="targets.txt"
instances_ip="instances_ip.txt"

# Kill old containers before start new
while IFS= read -r instance
do
  command="sudo docker kill \$(sudo docker ps -q)"
  echo "$instance '$command' < /dev/null"
  eval "$instance '$command' < /dev/null"
done < "$instances_ip"

# Start working with targets and instances through ssh
while IFS= read -r target
do
  while IFS= read -r instance
  do
    command="sudo docker run -d -it --rm alpine/bombardier -c 1666 -d 8666s -l $target"
    echo "$instance '$command' < /dev/null"
    eval "$instance '$command' < /dev/null"
  done < "$instances_ip"
done < "$targets_list"