#! /bin/bash

# echo "password: $2"
BRANCH=master
if [ ! -z "$1" ]; then
    echo "pull branch: $1"
    BRANCH=$1
fi

echo "------------------------------------------------------------------------"
echo "---------------------------pull Deep-Learning--------------------------------"
echo "------------------------------------------------------------------------"
git pull

CONFLICTS=$(git ls-files -u | wc -l)
if [ "$CONFLICTS" -gt 0 ] ; then
   echo "There is conflict in Deep-Learning. Aborting"
   return 1
fi

cd ~/Deep-Learning
return 0