#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

cp $DUCK_PATH ./

rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/DuckCorp/Duck/1.0.0/Duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE

read -d '' CONTENTS << EOF
apply plugin: 'maven-publish'

configurations { compile }

dependencies {
    compile (group: 'ArtifactGroup', name: 'ArtifactName', version: 'ArtifactVersiono') //Replace this with your artifact info
}

task('productZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.compile
    }
    archiveName "Duck.zip"
}

publishing.publications {
    duckPublication(MavenPublication) {
        artifact    tasks.getByName('productZip')
        groupId     'DuckCorp'
        artifactId  'DuckZip'
        version     '1.0.0'
    }
}
EOF

echo "$CONTENTS" >> build.gradle

echo "Setup complete."
echo "Follow the instructions in the readme file."
echo "URL for your artifactory server is:"
echo "$ARTIFACTORY_URL/webapp"
echo ""
