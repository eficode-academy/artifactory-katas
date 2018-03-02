#!/bin/bash

source ../.shared/utils.sh

rest_delete_repository $REPO_NAME
rest_create_repository $REPO_NAME
rest_create_repository "$REPO_NAME""2"
