#!/bin/bash

#Stuff for user to fill out
USERNAME="mim"
ARTIFACTORY_URL='http://localhost:8081/artifactory'
ARTIFACTORY_USERNAME="admin"
ARTIFACTORY_PASSWORD="password"

REPO_NAME="artifactory_katas-$USERNAME"
BASE64=$(echo -n "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" | base64)
AUTH_HEADER="Authorization: Basic $BASE64"
echo $AUTH_HEADER

DUCK_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Duck.jpg"
echo $DUCK_PATH

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