#!/bin/bash

source ../.shared/utils.sh
initkata

#rest_delete_repository $REMOTE_REPO
rest_create_repository $MATURITY_1_REPO "gradle"
rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_3_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"

populate_maturity_repos
cp ../../.shared/aql/payload.aql .
arr=( "ARTIFACTORY_URL" "AUTH_HEADER")
echo " "
echo " "
echo_variable_array ${arr[@]}
echo " "
echo " "
echo 'To use your aql, make a json file and use curl like the example below:'
echo 'curl -i -X POST -H "${AUTH_HEADER}"  -H "Content-Type:text/plain" "${ARTIFACTORY_URL}/api/search/aql" -T payload.aql'

get_and_config_jfrog_cli

echo "Setup done."
echo "Remember to navigate to the created exercise folder."
