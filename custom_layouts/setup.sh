#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE

cp $DUCK_PATH ./duck-$KATA_USERNAME.jpg
cp $FOX_PATH ./fox-$KATA_USERNAME.jpg

rest_deploy_artifact "/$GRADLE_REPO1/acme/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/acme/fox/1.0.0/fox-1.0.0.jpg" "$FOX_PATH"  &>> $LOGFILE

read -d '' CONTENTS <<EOF
apply plugin: "java"
repositories {
    ivy {
        url "http://${ARTIFACTORY_URL}/YOUR_CUSTOM_REPO_GOES_HERE" //This is where you put your custom repo name

        layout 'pattern' , {
            artifact '[organization]/[revision]/[artifact]-[revision](.[ext])' //This is your custom layout translated to ivy. This has to be done manually
            ivy '[module]/[revision]/ivy.xml'
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
echo ""
echo "The duck and fox images are in the exercise folder for use in the exercise."
echo "Remember to navigate to the exercises folder created."