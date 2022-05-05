#!/bin/bash

source ../.shared/utils.sh
initkata

rest_create_repository $MATURITY_1_REPO "gradle"
rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_3_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"

populate_maturity_repos
cp ../../.shared/aql/payload.json .
cp ../../.shared/aql/filespec.json .
arr=( "ARTIFACTORY_URL" "AUTH_HEADER")
echo_variable_array ${arr[@]}
echo 'To use your aql, make a json file and use curl like the example below:'
echo 'curl -i -X POST -H "$AUTH_HEADER"  -H "Content-Type:text/plain" "$ARTIFACTORY_URL"/api/search/aql -T payload.json'


get_and_config_jfrog_cli

echo "Setup done."
echo "Remember to navigate to the exercises folder created."
