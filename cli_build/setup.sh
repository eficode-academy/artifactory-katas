#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"

cp $FOX_PATH .
get_and_config_jfrog_cli

echo ""
echo "These are the Gradle repositories that have been set up:"
echo "$MATURITY_2_REPO"
echo "$MATURITY_4_REPO"
echo ""
echo "Setup done."
echo "Remember to navigate to the created exercise folder."
