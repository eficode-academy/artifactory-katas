#!/bin/bash

source ../.shared/utils.sh
initkata

cp $DUCK_PATH ./duck-$KATA_USERNAME.jpg
cp $FOX_PATH ./fox-$KATA_USERNAME.jpg
cp $FROG_PATH ./frog-$KATA_USERNAME.jpg
cp $MOOSE_PATH ./moose-$KATA_USERNAME.jpg
cp $SQUIRREL_PATH ./squirrel-$KATA_USERNAME.jpg

echo ""
echo "These are the Repository Keys you should use for your generic repositories:"
echo "1: $GENERIC_REPO1"
echo "2: $GENERIC_REPO2"
echo ""
echo "Remember to navigate to the exercises folder created."
