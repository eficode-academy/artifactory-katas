#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $GRADLE_REPO1 "generic"
rest_deploy_artifact "/$GRADLE_REPO1/duck.jpg" "$DUCK_PATH"