#!/bin/bash

source ../.shared/utils.sh
initkata

rest_delete_repository $GRADLE_REPO1
rest_create_repository $GRADLE_REPO1
rest_delete_repository $GRADLE_REPO2
rest_create_repository $GRADLE_REPO2

