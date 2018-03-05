#!/bin/bash

CONFIG=$(pwd)/$(dirname $BASH_SOURCE)"/config.txt"
LOGFILE=$(pwd)/$(dirname $BASH_SOURCE)"/log.txt"

DUCK_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Duck.jpg"
FOX_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Fox.jpg"
FROG_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Frog.jpg"
MOOSE_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Moose.jpg"
SQUIRREL_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Squirrel.jpg"

initkata() {
    source $CONFIG
    if [ -z "$KATA_USERNAME" ] || [ -z "$ARTIFACTORY_URL" ] || [ -z "$ARTIFACTORY_USERNAME" ] || [ -z "$ARTIFACTORY_PASSWORD" ]; then
        echo "Configuration not found. Creating new config file..."
        echo ""
        create_config
        source $CONFIG
    fi

    GRADLE_REPO1="$KATA_USERNAME-generic-gradle-1"
    GRADLE_REPO2="$KATA_USERNAME-generic-gradle-2"
    CUSTOM_REPO1="$KATA_USERNAME-custom-layout-repo"
    VIRTUAL_REPO1="$KATA_USERNAME-virtual-1"
    VIRTUAL_REPO2="$KATA_USERNAME-virtual-2"

    BASE64=$(echo -n "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" | base64)
    AUTH_HEADER="Authorization: Basic $BASE64"

    echo "[KATA] Cleaning up old exercise folder..."
    rm -rf exercise/

    echo "[KATA] Cleaning up old repositories on Artifactory..."
    rest_delete_repository $GRADLE_REPO1 &>> $LOGFILE
    rest_delete_repository $GRADLE_REPO2 &>> $LOGFILE
    rest_delete_repository $CUSTOM_REPO1 &>> $LOGFILE
    rest_delete_repository $VIRTUAL_REPO1 &>> $LOGFILE
    rest_delete_repository $VIRTUAL_REPO2 &>> $LOGFILE

    echo "[KATA] Initializing new exercise folder..."
    mkdir exercise
    cd exercise
}

create_config() {
    rm -f $CONFIG

    echo "Please enter your Artifactory URL: "
    read INPUT_ARTIFACTORY_URL
    echo ""

    echo "Please enter your Artifactory username (for authentication): "
    read INPUT_ARTIFACTORY_USERNAME
    echo ""

    echo "Please enter your Artifactory password (for authentication): "
    read -s INPUT_ARTIFACTORY_PASSWORD
    echo ""

    echo "Please enter your unique kata username (used for naming your repositories): "
    read INPUT_KATA_USERNAME
    echo ""

    echo "ARTIFACTORY_URL=$INPUT_ARTIFACTORY_URL" >> $CONFIG
    echo "ARTIFACTORY_USERNAME=$INPUT_ARTIFACTORY_USERNAME" >> $CONFIG
    echo "ARTIFACTORY_PASSWORD=$INPUT_ARTIFACTORY_PASSWORD" >> $CONFIG
    echo "KATA_USERNAME=$INPUT_KATA_USERNAME" >> $CONFIG
}

#Runs a generic POST query
#$1 URI (example: "/api/search/aql")
#$2 Content type (Example: "text/plain")
#$3 Query
rest_post() {
    curl -i -X POST \
        -H "Content-Type:$2" \
        -H "$AUTH_HEADER" \
        -d \
    "$3" \
    "$ARTIFACTORY_URL$1"
}

#Creates a repository
#$1 repository name
rest_create_repository() {
    curl -i -X PUT \
        -H "Content-Type:application/json" \
        -H "$AUTH_HEADER" \
        -d \
    "{ \
    \"rclass\": \"local\", \
    \"packageType\" : \"generic\"
    }" \
    "$ARTIFACTORY_URL/api/repositories/$1"
}

#Deletes a repository
#$1 repository name
rest_delete_repository() {
    curl -i -X DELETE \
        -H "$AUTH_HEADER" \
    "$ARTIFACTORY_URL/api/repositories/$1"
}

#Uploads an artifact
#$1 upload path (repository/path/you/want/file.txt)
#$2 file path on disk
rest_deploy_artifact() {
    curl -i -X PUT \
        -H "$AUTH_HEADER" \
        -T "$2" \
    "$ARTIFACTORY_URL$1"
}