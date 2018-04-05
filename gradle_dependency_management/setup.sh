#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

cp $DUCK_PATH ./

rest_create_repository $GRADLE_REPO1 "gradle"
rest_deploy_artifact "/$GRADLE_REPO1/DuckCorp/Duck/1.0.0/Duck-1.0.0.jpg" "$DUCK_PATH"

read -d '' CONTENTS << EOF
apply plugin: 'maven-publish'
configurations{
    compile
}
repositories {
    maven { url "$ARTIFACTORY_URL/$GRADLE_REPO1" }
}
dependencies {
    compile 'groupId:artifactId:version' #Replace this with your artifact info
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
EOF

echo "$CONTENTS" >> build.gradle

echo ""
echo "This is the Gradle repository that has already been set up:"
echo "1: $GRADLE_REPO1"
echo ""

echo ""
echo "This is the name you should use when you set up your own Gradle repository:"
echo "2: $GRADLE_REPO2"
echo ""