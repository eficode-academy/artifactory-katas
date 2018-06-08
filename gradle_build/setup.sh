#!/bin/bash

source ../.shared/utils.sh
initkata

gradle -q init

#rest_create_remote_repository $REMOTE_REPO "gradle" "maven-2-default" "https://jcenter.bintray.com" &>> $LOGFILE # User creates remote repo themselves https://github.com/praqma-training/artifactory-katas/issues/45
rest_create_repository $MATURITY_2_REPO "gradle" &>> $LOGFILE
rest_create_repository $MATURITY_4_REPO "gradle" &>> $LOGFILE
rest_deploy_artifact "/$MATURITY_2_REPO/duckcorp/duck/1.0.0/duck-1.0.0.jpg" "$DUCK_PATH" &>> $LOGFILE
rest_deploy_artifact "/$MATURITY_2_REPO/moosecorp/moose/1.0.0/moose-1.0.0.jpg" "$MOOSE_PATH" &>> $LOGFILE

read -d '' CONTENTS_GRADLE_PROPERTIES <<EOF
artifactory_user=$ARTIFACTORY_USERNAME
artifactory_password=$ARTIFACTORY_PASSWORD
artifactory_contextUrl=$ARTIFACTORY_URL
EOF
echo "$CONTENTS_GRADLE_PROPERTIES" >> gradle.properties

read -d '' CONTENTS << EOF
buildscript {
    repositories {
        maven { url "\${artifactory_contextUrl}/$REMOTE_REPO" }
        
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
    clientConfig.setIncludeEnvVars(true)
    publish {
        repository {
            repoKey = '$MATURITY_2_REPO'
            username = "\${artifactory_user}"
            password = "\${artifactory_password}"
            maven = true
            
        }
            defaults {
                publications ('duckPublication','moosePublication')

                // This is where you can add default properties that will apply to all artifacts

                // This is also where you can add a properties{} closure that sets properties on specific artifacts

        }
    }
    resolve {
        repository {
            repoKey = '$MATURITY_2_REPO'
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
    DuckFiles(group: 'duckcorp', name: 'duck', version: '1.0.+', ext: 'jpg')
    MooseFiles(group: 'moosecorp', name: 'moose', version: '1.0.+', ext: 'jpg')
}

task('DuckZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.DuckFiles
    }
    archiveName "duck.zip"
}

task('MooseZip', type: Zip) {
    group "Publish"
    description "Creates a product tar archive for publication"
    outputs.upToDateWhen { false }
    from {
        configurations.MooseFiles
    }
    archiveName "moose.zip"
}

publishing.publications {
    duckPublication(MavenPublication) {
        artifact    tasks.getByName('DuckZip')
        groupId     'duckcorp'
        artifactId  'duckzip'
        version     '1.0.0'
    }
    moosePublication(MavenPublication) {
        artifact    tasks.getByName('MooseZip')
        groupId     'moosecorp'
        artifactId  'moosezip'
        version     '1.0.0'
    }
}

import groovy.json.JsonSlurper
task('PromoteBuild', type: Exec) {
    String username = "\${artifactory_user}"
    String password = "\${artifactory_password}"
    def creds = "\$username:\$password".bytes.encodeBase64()
    def authHeader = "Authorization: Basic \$creds"

    def myBuildName = "yourBuildName" //Enter your build name here
    def myBuildNumber = "yourBuildNumber" //Enter your build number here

    workingDir '.'
    commandLine 'curl', '-s', '-X', 'POST', '-H', 'Content-Type:application/json', '-H', "\\\\"\$authHeader\\\\"", "-d", '@promote_build_query.json', "\${artifactory_contextUrl}/api/build/promote/\$myBuildName/\$myBuildNumber"

    standardOutput = new ByteArrayOutputStream()
    doLast {
        def json = new JsonSlurper().parseText(standardOutput.toString())
        if ( json?.errors?.status ) {
            println "HTTP error when trying to promote build. Dumping full JSON response:"
            println standardOutput.toString()
            throw new GradleException("HTTP error when trying to promote build")
        }
    }
}
EOF

echo "$CONTENTS" >> build.gradle

read -d '' CONTENTS_PROMOTE_BUILD <<EOF
{
    \"status\" : \"Released\",
    \"sourceRepo\" : \"$MATURITY_2_REPO\",
    \"targetRepo\" : \"$MATURITY_4_REPO\"
}
EOF
echo "$CONTENTS_PROMOTE_BUILD" >> promote_build_query.json

echo ""
echo "This is the Gradle repository that has been set up:"
echo "$MATURITY_2_REPO"
echo "Visit it in the UI:"
echo "$ARTIFACTORY_URL/webapp/#/artifacts/browse/tree/General/$MATURITY_2_REPO"
echo ""
echo "Remember to navigate to the exercises folder created."