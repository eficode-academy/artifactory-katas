#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $MATURITY_1_REPO "gradle"
rest_create_repository $MATURITY_2_REPO "gradle"
rest_create_repository $MATURITY_3_REPO "gradle"
rest_create_repository $MATURITY_4_REPO "gradle"

cp $DUCK_PATH ./duck-$KATA_USERNAME.jpg
cp $FOX_PATH ./fox-$KATA_USERNAME.jpg

rest_deploy_artifact "/$MATURITY_1_REPO/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_3_REPO/acme/duck/1.3.0/duck-1.3.0.jpg" "$DUCK_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_2_REPO/acme/fox/2.3.0/fox-2.3.0.jpg" "$FOX_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$MATURITY_4_REPO/acme/fox/1.5.3/fox-1.5.3.jpg" "$FOX_PATH"  >> $LOGFILE 2>&1

read -d '' CONTENTS << EOF
repositories {
    maven { url "$ARTIFACTORY_URL/$MATURITY_1_REPO" }  // Fill in your virtual repository here
}

configurations { compile }

dependencies {

    compile(group: 'acme', name: 'duck', version: '1.0.0', ext: 'jpg')

    // Add your dependencies here

}

EOF
echo "$CONTENTS" >> build.gradle

echo "Setup done. The duck and fox images are in the exercise folder for use in the exercise."
echo "Remember to navigate to the exercises folder created."
