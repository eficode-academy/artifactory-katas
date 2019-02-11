#!/bin/bash

source ../.shared/utils.sh

# Read config variables and see if using apikey, for early-exit error message
read_config_variables

if [[ -z "$ARTIFACTORY_USERNAME" || -z "$ARTIFACTORY_PASSWORD" ]]; then
    echo "[KATA] This exercise can only be done using username/password authentication."
    echo "[KATA] - The Gradle Artifactory Plugin currently doesn't support API auth."
    echo "[KATA] See GAP-242, on https://www.jfrog.com/jira/browse/GAP-242 for more info."
    echo ""
    echo "[KATA] To recreate your config with username/password authentication:"
    echo "[KATA] 1. delete or rename the file .shared/config.txt"
    echo "[KATA] 2. rerun setup.sh"
    exit
fi

initkata

gradle -q init

#rest_create_remote_repository $REMOTE_REPO "gradle" "maven-2-default" "https://jcenter.bintray.com" >> $LOGFILE 2>&1 # User creates remote repo themselves https://github.com/praqma-training/artifactory-katas/issues/45
rest_create_repository $MATURITY_2_REPO "gradle" >> $LOGFILE 2>&1
rest_create_repository $MATURITY_4_REPO "gradle" >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_2_REPO/duckcorp/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH" >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_2_REPO/moosecorp/moose/1.0.0/moose-1.0.0.jpg" "$MOOSE_PATH" >> $LOGFILE 2>&1

../helpers/gradle-userpass.sh

read -d '' CONTENTS_PROMOTE_BUILD <<EOF
{
    \"status\" : \"Released\",
    \"sourceRepo\" : \"$MATURITY_2_REPO\",
    \"targetRepo\" : \"$MATURITY_4_REPO\"
}
EOF
echo "$CONTENTS_PROMOTE_BUILD" >> promote_build_query.json

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$MATURITY_2_REPO"
echo "Visit it in the UI:"
echo "$ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$MATURITY_2_REPO"
echo ""
echo "Remember to navigate to the exercises folder created."
