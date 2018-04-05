#!/bin/bash

source ../.shared/utils.sh
initkata

rest_delete_repository $GRADLE_REPO1
rest_create_repository $GRADLE_REPO1
rest_delete_repository $GRADLE_REPO2
rest_create_repository $GRADLE_REPO2
rest_delete_repository $GRADLE_REPO3
rest_create_repository $GRADLE_REPO3
#DUCK_URL=acme/duck/1.0.0/duck-1.0.0.jpg
#rest_deploy_artifact "/$GRADLE_REPO1/$DUCK_URL" "$DUCK_PATH"
#download_artifact 10 "$GRADLE_REPO1/$DUCK_URL"
populate_repos