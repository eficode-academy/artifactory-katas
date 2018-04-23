#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.1/duck-1.0.1.jpg" "$DUCK2_PATH"  &>> $LOGFILE

read -d '' CONTENTS << EOF
repositories {
    // Your repository goes here
}

configurations { compile }

dependencies {
    compile (group: 'ArtifactGroup', name: 'ArtifactName', version: 'ArtifactVersion', ext: 'jpg') //Replace this with your artifact info
}

task('productZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.compile
    }
    archiveName "duck.zip"
}
EOF

echo "$CONTENTS" >> build.gradle

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$GRADLE_REPO1"
echo "Visit it in the UI:"
echo "$ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$GRADLE_REPO1"
echo ""