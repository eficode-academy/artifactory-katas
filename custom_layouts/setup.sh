#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $GRADLE_REPO1 "gradle"

cp $DUCK_PATH ./duck-$KATA_USERNAME.jpg
cp $FOX_PATH ./fox-$KATA_USERNAME.jpg

rest_deploy_artifact "/$GRADLE_REPO1/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$GRADLE_REPO1/acme/fox/1.0.0/fox-1.0.0.jpg" "$FOX_PATH"  >> $LOGFILE 2>&1

read -d '' CONTENTS <<EOF
apply plugin: "java"
repositories {
    ivy {
        url "${ARTIFACTORY_URL}/YOUR_CUSTOM_REPO_GOES_HERE" // This is where you put your custom repo name
        credentials {
            username = "${artifactory_user}" // The publisher user name
            password = "${artifactory_password}" // The publisher password
        }
        patternLayout {
            artifact '[organization]/[revision]/[artifact]-[revision](.[ext])' // This is your custom layout translated to ivy. This has to be done manually
            ivy '[module]/[revision]/ivy.xml'
        }
        metadataSources {
            artifact()
        }
    }
}
configurations {
    deps
}
  dependencies {
    deps (group: 'acme', name: 'duck', version: '1.0.0', ext: 'jpg')
    deps (group: 'acme', name: 'fox', version: '1.0.0', ext: 'jpg')
}
  task copyDeps(type: Copy) {
    from configurations.deps
    into "\$buildDir/output"
}
EOF
echo "$CONTENTS" >> build.gradle

echo "Setup complete."
echo "Follow the instructions in the readme file."
echo "Your repo for this exercise is: $ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$GRADLE_REPO1"
arr=("KATA_USERNAME")
echo_variable_array ${arr[@]}
echo ""
echo "The duck and fox images are in the exercise folder for use in the exercise."
echo "Remember to navigate to the exercises folder created."
