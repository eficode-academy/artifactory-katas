#!/bin/bash

source ../.shared/utils.sh
initkata

MATURITY_1_REPO="$KATA_USERNAME-gradle-sandbox-local"
MATURITY_2_REPO="$KATA_USERNAME-gradle-dev-local"
MATURITY_3_REPO="$KATA_USERNAME-gradle-v3-local"
MATURITY_4_REPO="$KATA_USERNAME-gradle-release-local"

rest_create_repository $MATURITY_1_REPO "gradle"
rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_3_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"


cp $DUCK_PATH ./
cp $FOX_PATH ./

rest_deploy_artifact "/$MATURITY_1_REPO/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$MATURITY_3_REPO/acme/duck/1.3.0/duck-1.3.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$MATURITY_2_REPO/acme/fox/2.3.0/fox-2.3.0.jpg" "$FOX_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$MATURITY_4_REPO/acme/fox/1.5.3/fox-1.5.3.jpg" "$FOX_PATH"  &>> $LOGFILE

echo "Setup done. The duck and fox images are in the exercise folder for use in the exercise."
