#!/bin/bash

source ../.shared/utils.sh

rest_delete_repository $GRADLE_REPO1
rest_create_repository $GRADLE_REPO1
rest_delete_repository $GRADLE_REPO2
rest_create_repository $GRADLE_REPO2

