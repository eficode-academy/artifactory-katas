#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE

read -d '' CONTENTS << EOF
apply plugin: 'maven-publish'

configurations { compile }

dependencies {
    compile(group: 'duckcorp', name: 'duck', version: '1.0.0', ext: 'jpg') // This is the already uploaded file
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

publishing.publications {
    duckPublication(MavenPublication) {
        artifact    tasks.getByName('productZip')
        groupId     'duckcorp'
        artifactId  'duckzip'
        version     '1.0.0'
    }
}
EOF

echo "$CONTENTS" >> build.gradle

echo "Setup complete."
echo "Follow the instructions in the readme file."
echo "URL for your artifactory server is:"
echo "$ARTIFACTORY_URL/webapp"
echo "artifactory_contextUrl is: $ARTIFACTORY_URL/$REMOTE_REPO"
echo ""
