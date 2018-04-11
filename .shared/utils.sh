#!/bin/bash

CONFIG=$(pwd)/$(dirname $BASH_SOURCE)"/config.txt"
LOGFILE=$(pwd)/$(dirname $BASH_SOURCE)"/log.txt"

DUCK_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Duck.jpg"
DUCK2_path=$(pwd)/$(dirname $BASH_SOURCE)"/Duck2.jpg"
FOX_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Fox.jpg"
FROG_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Frog.jpg"
MOOSE_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Moose.jpg"
SQUIRREL_PATH=$(pwd)/$(dirname $BASH_SOURCE)"/Squirrel.jpg"

initkata() {
    echo "[KATA] Reading config file..."
    read_config_variables
    echo "[KATA] Pinging Artifactory..."
    ping_artifactory

    echo "[KATA] Stopping any running gradle daemons..."
    gradle --stop #Stopping any gradle daemons to avoid Windows acting crazy when removing directory
    
    echo "[KATA] Cleaning up old exercise folder..."
    rm -rf exercise/

    echo "[KATA] Cleaning up old repositories on Artifactory..."
    rest_delete_repository $GRADLE_REPO1 &>> $LOGFILE
    rest_delete_repository $GRADLE_REPO2 &>> $LOGFILE
    rest_delete_repository $GRADLE_REPO3 &>> $LOGFILE
    rest_delete_repository $CUSTOM_REPO1 &>> $LOGFILE
    rest_delete_repository $VIRTUAL_REPO1 &>> $LOGFILE
    rest_delete_repository $VIRTUAL_REPO2 &>> $LOGFILE

    echo "[KATA] Initializing new exercise folder..."
    mkdir exercise
    cd exercise
    
    echo " "
}

#Sources config file, reads variables, calls create_config if something is missing 
read_config_variables() {
    source $CONFIG
    if [ -z "$KATA_USERNAME" ] || [ -z "$ARTIFACTORY_URL" ] || [ -z "$ARTIFACTORY_USERNAME" ] || [ -z "$ARTIFACTORY_PASSWORD" ]; then
        echo "[KATA] Configuration not found. Creating new config file..."
        echo ""
        create_config
        source $CONFIG
    fi

    GRADLE_REPO1="$KATA_USERNAME-generic-gradle-1"
    GRADLE_REPO2="$KATA_USERNAME-generic-gradle-2"
    GRADLE_REPO3="$KATA_USERNAME-generic-gradle-3"
    MATURITY_1_REPO="$KATA_USERNAME-gradle-sandbox-local"
    MATURITY_2_REPO="$KATA_USERNAME-gradle-dev-local"
    MATURITY_3_REPO="$KATA_USERNAME-gradle-v3-local"
    MATURITY_4_REPO="$KATA_USERNAME-gradle-release-local"
    CUSTOM_REPO1="$KATA_USERNAME-custom-layout-repo"
    VIRTUAL_REPO1="$KATA_USERNAME-virtual-1"
    VIRTUAL_REPO2="$KATA_USERNAME-virtual-2"

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
        echo "[KATA] HTTP 404: Page not found. Most likely you have put an '/' at the end of your URL. Your URL should look like 'http://serverAddress.com/artifactory'"
        create_config
    elif [ "$PING_RESULT" -ne "200" ]; then
        echo "[KATA] Unexpected result when pinging Artifactory. Redoing the command in terminal so someone can debug what is going on..."
        curl -i --max-time 5 -X GET -H "$AUTH_HEADER" "$ARTIFACTORY_URL/api/application.wadl"
    fi
}

create_config() {
    rm -f $CONFIG

    echo "[KATA] Your Artifactory URL should look like 'http://serverAddress.com/artifactory' - note that there is no trailing '/' at the end."
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

#Downloads an artifact X times
#$1 is the number of times it should be downloaded
#$2 is the url path of the file
download_artifact(){

COUNTER=0
echo "downloading $ARTIFACTORY_URL/$2 $1 times"
while [  $COUNTER -lt $1 ]; do
    curl $ARTIFACTORY_URL$2 > /dev/null 2>&1
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
        echo "deploying version $i of ${names[$o]}" &>> $LOGFILE
        URL="/$GRADLE_REPO1/acme/${names[$o]}/$i/${names[$o]}-$i.jpg"
        rest_deploy_artifact "$URL" "${paths[$o]}" &>> $LOGFILE
        if (( RANDOM % 2 )); 
        then
            download_artifact $((RANDOM%10)) "$URL" &>> $LOGFILE
        fi
    done
done
echo "population done"
}