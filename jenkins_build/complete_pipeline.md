
### Resulting pipeline

```groovy
def artifactory_url="http://ec2-18-197-71-5.eu-central-1.compute.amazonaws.com:8081/artifactory"
def username="admin"
def encrypted_password="APAT9oNtyf6omxAz" // generate it from your Artifactory profile

node {
    def server = Artifactory.newServer url: artifactory_url, username: username, password: encrypted_password
    def buildInfo = Artifactory.newBuildInfo()
    buildInfo.env.capture = true
    stage('Preparation') { // for display purposes
        // This is where you normally checkout your source repository
        deleteDir() //Deletes the entire workspace content
    }
    stage('Build') {
        // "build" some software
        writeFile file: "artifact-1.${currentBuild.number}.txt", text: "this is our artifact from 1.${currentBuild.number}"
        sh "ls -la" //List the artifacts in the log to see if the file is present
    }

    stage('Upload') {
        // PART 1 - Add upload spec here and upload "build.txt" to Artifactory
        def uploadSpec = """{
            "files": [
            {
              "pattern": "artifact-1.${currentBuild.number}.txt",
              "target": "sal-gradle-sandbox-local/acme/artifact/1.${currentBuild.number}/artifact-1.${currentBuild.number}.txt"
            }
            ]
        }"""
        server.upload spec: uploadSpec, buildInfo: buildInfo
        server.publishBuildInfo buildInfo
    }
    stage('Download') {
        deleteDir() //Deletes the entire workspace, so we rely 100% on Artifactory
        // PART 2 - Add download spec here and download "artifact.txt" and "artifact.tgz" from Artifactory
        def downloadSpec = """{
            "files": [
                {
                    "pattern": "sal-gradle-sandbox-local/acme/artifact/1.${currentBuild.number}/artifact-1.${currentBuild.number}.txt"
                    , "flat": "true"
                }
            ]
        }"""
        server.download spec: downloadSpec, buildInfo: buildInfo
        sh "ls -la"
    }
    stage ('Automatic Promote'){
        // PART 3 - Promote the build to the next level
        def promotionConfig = [
            // Mandatory parameters
            'buildName'         : buildInfo.name,
            'buildNumber'       : buildInfo.number,
            'targetRepo'        : 'sal-gradle-dev-local', //name of the repo to promote the artifacts to
            'status'            : 'promoted to dev'
        ]
        // Promote build
        server.promote promotionConfig
    }
    stage ('Interactive Promote'){
        // PART 4 - Interactively promote the build to the next level
        def promotionConfig = [
            // Mandatory parameters
            'buildName'         : buildInfo.name,
            'buildNumber'       : buildInfo.number,
            'targetRepo'        : 'sal-gradle-regtest-local', //name of the repo to promote the artifacts to
            'status'            : 'promoted to regtest'
        ]
        Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig
    }
}
```
