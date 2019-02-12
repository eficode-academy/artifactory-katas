#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"

cp $MOOSE_PATH .
cp $SQUIRREL_PATH .
cp $FOX_PATH .
curl -fL https://getcli.jfrog.io | sh
./jfrog rt config --url $ARTIFACTORY_URL --user $ARTIFACTORY_USERNAME --password $ARTIFACTORY_PASSWORD --interactive=false

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$MATURITY_2_REPO"
echo ""
echo "Setup done."
echo "Remember to navigate to the exercises folder created."