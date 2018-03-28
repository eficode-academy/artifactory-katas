#!/bin/bash

source ../.shared/utils.sh
initkata
# upload duck-1.0.0.jpg and fox-1.0.0.jpg

rest_delete_repository $GRADLE_REPO1
rest_create_repository $GRADLE_REPO1

