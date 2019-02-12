#!/bin/bash

CONFIG=$(pwd)/$(dirname $BASH_SOURCE)"/config.txt"
LOGFILE=$(pwd)/$(dirname $BASH_SOURCE)"/log.txt"
rm -f $LOGFILE

DUCK_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/duck.jpg"
DUCK2_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/duck2.jpg"
FOX_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/fox.jpg"
FROG_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/frog.jpg"
MOOSE_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/moose.jpg"
SQUIRREL_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/squirrel.jpg"

initkata() {
    echo "[KATA] Reading config file..."
    read_config_variables
    echo "[KATA] Pinging Artifactory..."
    ping_artifactory

    echo "[KATA] Which gradle are you using:"
    which gradle

    if [ -d "$(pwd)/exercise" ]; then
        echo "[KATA] Stopping any running gradle daemons..."
        gradle --stop #Stopping any gradle daemons to avoid Windows acting crazy when removing directory
    fi

    echo "[KATA] Cleaning up old exercise folder..."
    rm -rf exercise/

    echo "[KATA] Cleaning up old repositories on Artifactory..."
    rest_delete_repository $GENERIC_REPO1 >> $LOGFILE 2>&1
    rest_delete_repository $GENERIC_REPO2 >> $LOGFILE 2>&1
    rest_delete_repository $GRADLE_REPO1 >> $LOGFILE 2>&1
    rest_delete_repository $GRADLE_REPO2 >> $LOGFILE 2>&1
    rest_delete_repository $GRADLE_REPO3 >> $LOGFILE 2>&1
    rest_delete_repository $CUSTOM_REPO1 >> $LOGFILE 2>&1
    rest_delete_repository $VIRTUAL_REPO1 >> $LOGFILE 2>&1
    rest_delete_repository $VIRTUAL_REPO2 >> $LOGFILE 2>&1
    rest_delete_repository $MATURITY_1_REPO >> $LOGFILE 2>&1
    rest_delete_repository $MATURITY_2_REPO >> $LOGFILE 2>&1
    rest_delete_repository $MATURITY_3_REPO >> $LOGFILE 2>&1
    rest_delete_repository $MATURITY_4_REPO >> $LOGFILE 2>&1
    #rest_delete_repository $REMOTE_REPO >> $LOGFILE 2>&1 #We no longer delete the remote repo due to proxy issues.

    echo "[KATA] Initializing new exercise folder..."
    mkdir exercise
    cd exercise

    echo " "
}

#Sources config file, reads variables, calls create_config if something is missing
read_config_variables() {
    if [ ! -f "$CONFIG" ]; then
        echo "[KATA] Configuration not found. Creating new config file..."
        echo ""
        create_config
    fi
    source "$CONFIG"
    if [ -z "$KATA_USERNAME" ] || [ -z "$ARTIFACTORY_URL" ] || [ -z "$ARTIFACTORY_USERNAME" ] || [ -z "$ARTIFACTORY_PASSWORD" ]; then
        echo "[KATA] Configuration corrupt. Creating new config file..."
        echo ""
        create_config
        source $CONFIG
    fi

    GENERIC_REPO1="$KATA_USERNAME-generic-1"
    GENERIC_REPO2="$KATA_USERNAME-generic-2"
    GRADLE_REPO1="$KATA_USERNAME-generic-gradle-1"
    GRADLE_REPO2="$KATA_USERNAME-generic-gradle-2"
    GRADLE_REPO3="$KATA_USERNAME-generic-gradle-3"
    MATURITY_1_REPO="$KATA_USERNAME-gradle-sandbox-local"
    MATURITY_2_REPO="$KATA_USERNAME-gradle-dev-local"
    MATURITY_3_REPO="$KATA_USERNAME-gradle-regtest-local"
    MATURITY_4_REPO="$KATA_USERNAME-gradle-release-local"
    CUSTOM_REPO1="$KATA_USERNAME-custom-layout-repo"
    VIRTUAL_REPO1="$KATA_USERNAME-virtual-1"
    VIRTUAL_REPO2="$KATA_USERNAME-virtual-2"
    REMOTE_REPO="$KATA_USERNAME-jcenter-remote"

    BASE64=$(echo -n "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" | base64)
    AUTH_HEADER="Authorization: Basic $BASE64"
}

#Checks that artifactory URL and credentials are correct by requesting the application.wadl file. If something isn't right, calls create_config.
ping_artifactory() {
    PING_RESULT=$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" -X GET -H "$AUTH_HEADER" "$ARTIFACTORY_URL/api/application.wadl")
    if [ "$PING_RESULT" -eq "000" ]; then
        echo "[KATA] HTTP 000: Failed to connect to $ARTIFACTORY_URL. Redirecting to new config file creation..."
        create_config
    elif [ "$PING_RESULT" -eq "401" ]; then
        echo "[KATA] HTTP 401: Connection successful but credentials are invalid. Redirecting to new config file creation..."
        create_config
    elif [ "$PING_RESULT" -eq "404" ]; then
        echo "[KATA] HTTP 404: Page not found. Most likely you have put an '/' at the end of your URL."
        echo "[KATA] Your URL should look like 'http://serverAddress.com/artifactory'"
        create_config
    elif [ "$PING_RESULT" -ne "200" ]; then
        echo "[KATA] Unexpected result when pinging Artifactory."
        echo "[KATA] Redoing the command in terminal so someone can debug what is going on..."
        curl -i --max-time 5 -X GET -H "$AUTH_HEADER" "$ARTIFACTORY_URL/api/application.wadl"
    fi
}

create_config() {

    PWD="$(pwd)"

    # A regex pattern to match for spaces
    PATTERN=" "

    # Check whether path contains spaces
    if [[ "$PWD" =~ "$PATTERN" ]]; then
        echo "[KATA] ERROR: Current path contains spaces:"
        echo "[KATA] \"$PWD\""
        echo "[KATA] Some of the startup scripts will not work."
        echo "[KATA] Please move the Artifactory Katas folder to a path without spaces."
        echo ""
        echo "[KATA] Aborting setup."
        exit
    fi

    echo "[KATA] I am about to create a new config file for you. Press ENTER to proceed, or ctrl+c to abort"
    read DUMMY_VARIABLE
    rm -f $CONFIG

    echo "[KATA] Your Artifactory URL should look like 'http://serverAddress.com/artifactory'"
    echo "[KATA] - note that there is no trailing '/' at the end."
    echo "[KATA] Please enter your Artifactory URL: "
    read INPUT_ARTIFACTORY_URL
    echo ""

    echo "[KATA] Please enter your Artifactory username (for authentication): "
    read INPUT_ARTIFACTORY_USERNAME
    echo ""

    echo "[KATA] Please enter your Artifactory password (for authentication): "
    read -s INPUT_ARTIFACTORY_PASSWORD
    echo ""

    echo "[KATA] Please enter your unique kata username (used for naming your repositories): "
    read INPUT_KATA_USERNAME
    echo ""

    echo "ARTIFACTORY_URL=$INPUT_ARTIFACTORY_URL" >> $CONFIG
    echo "ARTIFACTORY_USERNAME=$INPUT_ARTIFACTORY_USERNAME" >> $CONFIG
    echo "ARTIFACTORY_PASSWORD=$INPUT_ARTIFACTORY_PASSWORD" >> $CONFIG
    echo "KATA_USERNAME=$INPUT_KATA_USERNAME" >> $CONFIG

    read_config_variables
    ping_artifactory
}

#Echoes a copy-pastable blob of text to export variables to user terminal
#$1 array of variable names
echo_variable_array() {
    echo "[KATA] Paste this into your terminal for easy access to the variables:"
    echo "-------------------------------------------------------------------------------"
    array=("$@")
    for i in "${array[@]}"
    do
        VAR_CONTENTS=$(eval "echo "\$$i"")
        echo "export $i=\"$VAR_CONTENTS\""
    done
    echo "-------------------------------------------------------------------------------"
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
#$2 packageType (generic, gradle, something else)
rest_create_repository() {
    curl -i -X PUT \
        -H "Content-Type:application/json" \
        -H "$AUTH_HEADER" \
        -d \
    "{ \
    \"rclass\": \"local\", \
    \"packageType\" : \"$2\"
    }" \
    "$ARTIFACTORY_URL/api/repositories/$1" >> "$LOGFILE" 2>&1
}

#Creates a remote repo
#$1 repository name
#$2 package type (maven, gradle, etc)
#$3 repo layout (maven-2-default)
#$4 remote url (https://jcenter.bintray.com)
rest_create_remote_repository() {
    curl -i -X PUT \
        -H "Content-Type:application/json" \
        -H "$AUTH_HEADER" \
        -d \
    "{ \
    \"rclass\": \"remote\", \
    \"packageType\": \"$2\", \
    \"url\": \"$4\", \
    \"repoLayoutRef\": \"$3\" \
    }" \
    "$ARTIFACTORY_URL/api/repositories/$1"
}

rest_create_user(){
    curl -i -X PUT \
     -H "Content-Type:application/json" \
        -H "$AUTH_HEADER" \
        -d \
    "{ \
      \"email\" : \"$2\", \
    \"password\": \"$1\" \
    }" \
    "$ARTIFACTORY_URL/api/security/users/$1"
}

#Deletes a repository
#$1 repository name
rest_delete_repository() {
    curl -i -X DELETE \
        -H "$AUTH_HEADER" \
    "$ARTIFACTORY_URL/api/repositories/$1"
}
rest_list_repository() {
    curl -s \
        -H "$AUTH_HEADER" \
    "$ARTIFACTORY_URL/api/repositories"
}

delete_all_repositories(){
REPOS=($(rest_list_repository | jq -r '.[].key'))
for i in "${REPOS[@]}"
do
rest_delete_repository $i
done
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
#Appends properties to a given artifact.
#For more info look at: https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API#ArtifactoryRESTAPI-ItemProperties
#$1 artifact path (repository/path/you/want/file.txt)
#$2 the properties, e.g: os=win,linux;qa=finnished;junit test=success
rest_add_artifact_properties(){
    curl -i -X PUT \
        -H "$AUTH_HEADER" \
    "$ARTIFACTORY_URL/api/storage/$1?properties=$2"
}

#Downloads an artifact X times
#$1 is the number of times it should be downloaded
#$2 is the url path of the file
download_artifact(){
COUNTER=0
echo "downloading $ARTIFACTORY_URL/$2 $1 times"
while [  $COUNTER -lt $1 ]; do
    rm -f ./test.jpg
    curl -o ./test.jpg $ARTIFACTORY_URL$2
    rm -f ./test.jpg
    let COUNTER=COUNTER+1
done
}

#Uploads all the files in the three different repos, and makes some fake downloads to simulate usage
populate_repos(){
echo "populating repo"
versions=("1.0.0" "1.4.0" "2.0.1" "3.5.6")
names=("duck" "fox" "frog" "moose" "squirrel")
paths=($DUCK_PATH $FOX_PATH $FROG_PATH $MOOSE_PATH $SQUIRREL_PATH)

for i in "${versions[@]}"
do
    for((o=0;o<${#names[@]};o++))
    do
        echo "deploying version $i of ${names[$o]}" >> $LOGFILE 2>&1
        URL="/$GRADLE_REPO1/acme/${names[$o]}/$i/${names[$o]}-$i.jpg"
        rest_deploy_artifact "$URL" "${paths[$o]}" >> $LOGFILE 2>&1
        if (( RANDOM % 2 ));
        then
            download_artifact $((RANDOM%10)) "$URL" >> $LOGFILE 2>&1
        fi
    done
done
echo "population done"
}

populate_maturity_repos(){
# deploy the artifacts
echo "[KATA] Deploying artifacts to Artifactory ...."
rest_deploy_artifact "/$MATURITY_1_REPO/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH" >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_3_REPO/acme/duck/1.3.0/duck-1.3.0.jpg" "$DUCK_PATH" >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_2_REPO/acme/fox/2.3.0/fox-2.3.0.jpg" "$FOX_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_4_REPO/acme/fox/1.5.3/fox-1.5.3.jpg" "$FOX_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_2_REPO/acme/frog/1.5.3/frog-1.5.3.jpg" "$FROG_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_1_REPO/acme/frog/2.0.0/frog-2.0.0.jpg" "$FROG_PATH"  >> $LOGFILE 2>&1
# download artifacts
echo "[KATA] Simulating download of the artifacts, please wait ....."
download_artifact 2 "/$MATURITY_1_REPO/acme/duck/1.0.0/duck-1.0.0.jpg" >> $LOGFILE 2>&1
download_artifact 3 "/$MATURITY_3_REPO/acme/duck/1.3.0/duck-1.3.0.jpg" >> $LOGFILE 2>&1
download_artifact 4 "/$MATURITY_2_REPO/acme/fox/2.3.0/fox-2.3.0.jpg" >> $LOGFILE 2>&1
download_artifact 5 "/$MATURITY_4_REPO/acme/fox/1.5.3/fox-1.5.3.jpg" >> $LOGFILE 2>&1
download_artifact 6 "/$MATURITY_2_REPO/acme/frog/1.5.3/frog-1.5.3.jpg" >> $LOGFILE 2>&1
download_artifact 9 "/$MATURITY_1_REPO/acme/frog/2.0.0/frog-2.0.0.jpg" >> $LOGFILE 2>&1

#set some properties on the files
rest_add_artifact_properties "/$MATURITY_1_REPO/acme/duck/1.0.0/duck-1.0.0.jpg" "os=linux" >> $LOGFILE 2>&1
rest_add_artifact_properties "/$MATURITY_3_REPO/acme/duck/1.3.0/duck-1.3.0.jpg" "os=linux;unit_test=sucess;integration_test=success" >> $LOGFILE 2>&1
rest_add_artifact_properties "/$MATURITY_2_REPO/acme/fox/2.3.0/fox-2.3.0.jpg" "os=windows;unit_test=sucess" >> $LOGFILE 2>&1
rest_add_artifact_properties "/$MATURITY_1_REPO/acme/frog/2.0.0/frog-2.0.0.jpg" "keep=true" >> $LOGFILE 2>&1
#rest_add_artifact_properties
}
