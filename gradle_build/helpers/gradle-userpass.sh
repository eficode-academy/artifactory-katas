#!/bin/bash

source ../../.shared/utils.sh

read_config_variables

read -d '' CONTENTS_GRADLE_PROPERTIES <<EOF
artifactory_user=$ARTIFACTORY_USERNAME
artifactory_password=$ARTIFACTORY_PASSWORD
artifactory_contextUrl=$ARTIFACTORY_URL
EOF
echo "$CONTENTS_GRADLE_PROPERTIES" >> gradle.properties

echo "loolol"
echo "artifactory_user=$ARTIFACTORY_APIKEY"

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
        println "This is the curl that will be attempted:"
        println "curl -s -X POST -H Content-Type:application/json -H \"$authHeader\" -d @promote_build_query.json ${artifactory_contextUrl}/api/build/promote/$myBuildName/$myBuildNumber"

        if (isFamily(FAMILY_MAC) || isFamily(FAMILY_UNIX)) {
            println "Since you are on a UNIX machine, this hacky groovy task cannot execute the curl for you. You will have to copy and paste it yourself."
        } else {
            def json = new JsonSlurper().parseText(standardOutput.toString())
            if ( json?.errors?.status ) {
                println "HTTP error when trying to promote build. Dumping full JSON response:"
                println standardOutput.toString()
                throw new GradleException("HTTP error when trying to promote build")
            }
        }
    }
}
EOF

echo "$CONTENTS" >> build.gradle
