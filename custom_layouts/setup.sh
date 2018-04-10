#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE

cp $DUCK_PATH ./
cp $FOX_PATH ./

rest_deploy_artifact "/$GRADLE_REPO1/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/acme/fox/1.0.0/fox-1.0.0.jpg" "$FOX_PATH"  &>> $LOGFILE

echo "Setup done. The duck and fox images are in the exercise folder for use in the exercise."