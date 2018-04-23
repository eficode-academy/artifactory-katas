#!/bin/bash

source ../.shared/utils.sh
initkata

cp $DUCK_PATH ./duck-$KATA_USERNAME.jpg
cp $FOX_PATH ./fox-$KATA_USERNAME.jpg
cp $FROG_PATH ./frog-$KATA_USERNAME.jpg
cp $MOOSE_PATH ./moose-$KATA_USERNAME.jpg
cp $SQUIRREL_PATH ./squirrel-$KATA_USERNAME.jpg

echo ""
echo "These are the names you should use for your gradle repositories:"
echo "1: $GRADLE_REPO1"
echo "2: $GRADLE_REPO2"
echo ""