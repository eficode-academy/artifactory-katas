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

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$GRADLE_REPO1"
echo "Visit it in the UI:"
echo "$ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$GRADLE_REPO1"
echo ""

echo ""
echo "This is the name you should use when you set up your remote repository:"
echo "$GRADLE_REPO2"
echo ""

echo ""
echo "This is the name you should use when you set up your own Gradle repository:"
echo "$GRADLE_REPO2"
echo ""