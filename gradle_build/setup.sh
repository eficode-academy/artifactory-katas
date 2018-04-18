#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

rest_create_remote_repository $REMOTE_REPO "gradle" "maven-2-default" "https://jcenter.bintray.com" &>> $LOGFILE
rest_create_repository $GRADLE_REPO1 "gradle"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/DuckCorp/Duck/1.0.0/Duck-1.0.0.jpg" "$DUCK_PATH"  &>> $LOGFILE
rest_deploy_artifact "/$GRADLE_REPO1/MooseCorp/Moose/1.0.0/Moose-1.0.0.jpg" "$MOOSE_PATH"  &>> $LOGFILE

read -d '' CONTENTS_GRADLE_PROPERTIES <<EOF
artifactory_user=$ARTIFACTORY_USERNAME
artifactory_password=$ARTIFACTORY_PASSWORD
artifactory_contextUrl=$ARTIFACTORY_URL
EOF

echo "$CONTENTS_GRADLE_PROPERTIES" >> gradle.properties

read -d '' CONTENTS << EOF
buildscript {
    repositories {
        maven { url "\${artifactory_contextUrl}/$KATA_USERNAME-jcenter-remote-repo" }
        
    }
    dependencies {
        classpath "org.jfrog.buildinfo:build-info-extractor-gradle:4+"
    }
}

allprojects {
    apply plugin: "com.jfrog.artifactory"
}

artifactory {
    contextUrl = "\${artifactory_contextUrl}"   //The base Artifactory URL if not overridden by the publisher/resolver
    publish {
        repository {
            repoKey = '$GRADLE_REPO1'
            username = "\${artifactory_user}"
            password = "\${artifactory_password}"
            maven = true
            
        }
                defaults {
            publications ('duckPublication','moosePublication')
        }
    }
    resolve {
        repository {
            repoKey = '$GRADLE_REPO1'
            username = "\${artifactory_user}"
            password = "\${artifactory_password}"
            maven = true
            
        }
    }
}

apply plugin: 'maven-publish'
configurations{
    DuckFiles
    MooseFiles
}
dependencies {
    DuckFiles(group: 'DuckCorp', name: 'Duck', version: '1.0.+', ext: 'jpg')
    MooseFiles(group: 'MooseCorp', name: 'Moose', version: '1.0.+', ext: 'jpg')
}

task('DuckZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.DuckFiles
    }
    archiveName "Duck.zip"
}

task('MooseZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.MooseFiles
    }
    archiveName "Moose.zip"
}

publishing.publications {
    duckPublication(MavenPublication) {
        artifact    tasks.getByName('DuckZip')
        groupId     'DuckCorp'
        artifactId  'DuckZip'
        version     '1.0.0'
    }
    moosePublication(MavenPublication) {
        artifact    tasks.getByName('MooseZip')
        groupId     'MooseCorp'
        artifactId  'MooseZip'
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