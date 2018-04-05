#!/bin/bash

source ../.shared/utils.sh
initkata

rest_delete_repository $GRADLE_REPO1
rest_create_repository $GRADLE_REPO1 "generic"
rest_delete_repository $GRADLE_REPO2
rest_create_repository $GRADLE_REPO2 "generic"
rest_delete_repository $GRADLE_REPO3
rest_create_repository $GRADLE_REPO3 "generic"
rest_deploy_artifact "/$GRADLE_REPO1/duck.jpg" "$DUCK_PATH"
arr=( "ARTIFACTORY_URL" "ARTIFACTORY_USERNAME" "ARTIFACTORY_PASSWORD" "KATA_USERNAME" "AUTH_HEADER" "DUCK_PATH" "FOX_PATH" "FROG_PATH" "MOOSE_PATH" "SQUIRREL_PATH" )
echo_variable_array ${arr[@]}