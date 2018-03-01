#!/bin/bash

source ../.shared/utils.sh
initkata

cp $DUCK_PATH ./
cp $FOX_PATH ./
cp $MOOSE_PATH ./
cp $SQUIRREL_PATH ./

echo ""
echo "These are the names you should use for your gradle repositories:"
echo "1: $GRADLE_REPO1"
echo "2: $GRADLE_REPO2"

echo "This is the name you should use for your custom layout:"
echo "katas-$USERNAME-layout"

echo "This is the name you should use for your custom repository:"
echo "3: $CUSTOM_REPO1"

echo "These are the names you should use for your virtual repositories:"
echo "4: $VIRTUAL_REPO1"
echo "5: $VIRTUAL_REPO2"