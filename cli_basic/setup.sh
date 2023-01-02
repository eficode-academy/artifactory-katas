#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_2_REPO "gradle"

cp $MOOSE_PATH .
cp $SQUIRREL_PATH .
get_and_config_jfrog_cli

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$MATURITY_2_REPO"
echo ""
echo "Setup done."
echo "Remember to navigate to the created exercise folder."
