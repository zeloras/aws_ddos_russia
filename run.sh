#!/bin/bash

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

targets_list="targets.txt"
instances_ip="instances_ip.txt"

# Generate active instances list into instances_ip.txt
python3 pscripts/generate_instances_list.py $AWS_ACCESS_KEY $AWS_SECRET_KEY $AWS_REGION


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