#!/bin/bash

source ../.shared/utils.sh

rest_delete_repository $REPO_NAME
rest_create_repository $REPO_NAME "generic"
rest_deploy_artifact "/$REPO_NAME/duck.jpg" "$DUCK_PATH"