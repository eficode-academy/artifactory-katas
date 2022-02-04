#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_repository $GRADLE_REPO1 "gradle"
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.0/duck-1.0.0.pom" "$POM_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.1/duck-1.0.1.jpg" "$DUCK2_PATH"  >> $LOGFILE 2>&1
rest_deploy_artifact "/$GRADLE_REPO1/duckcorp/duck/1.0.1/duck-1.0.1.pom" "$POM2_PATH"  >> $LOGFILE 2>&1
read -d '' CONTENTS << EOF
plugins {
    id 'java'
}

repositories {
    maven {
    // Your repository goes here. Do not forget to set up authentication!
    }
}

configurations {
    implementation
}
// gradle will complain about implementation being 'canBeResolved=false' otherwise
configurations.implementation.setCanBeResolved(true)

dependencies {
    implementation (group: 'ArtifactGroup', name: 'ArtifactName', version: 'ArtifactVersion', ext: 'jpg') 
    // Replace this with your artifact info, grab it from the artifact!
}


task('productZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.implementation
    }
    setArchiveFileName "duck.zip"
}
EOF

echo "$CONTENTS" >> build.gradle

read -d '' CONTENTS << EOF

artifactory_user=$ARTIFACTORY_USERNAME
artifactory_password=$ARTIFACTORY_PASSWORD
artifactory_contextUrl=$ARTIFACTORY_URL
EOF
echo "$CONTENTS" >> gradle.properties

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$GRADLE_REPO1"
echo "Visit it in the UI:"
echo "$ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$GRADLE_REPO1"
echo ""
echo "Remember to navigate to the exercises folder created."
