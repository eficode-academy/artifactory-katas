
### Resulting pipeline

```groovy
def artifactory_url="http://ec2-18-197-71-5.eu-central-1.compute.amazonaws.com:8081/artifactory"
def username="admin"
def encrypted_password="orange" // generate it from your Artifactory profile

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
        writeFile file: "acme-1.${currentBuild.number}.txt", text: "this is our artifact from 1.${currentBuild.number}"
        sh "tar -zcvf acme-1.${currentBuild.number}.tgz acme-1.${currentBuild.number}.txt"
        sh "ls -la"
        archiveArtifacts '**/*.*'
    }
    stage('Upload') {
        def uploadSpec = """{
  "files": [
       {
      "pattern": "acme-1.${currentBuild.number}.txt",
      "target": "sal-gradle-sandbox-local/com/acme/1.${currentBuild.number}/acme-1.${currentBuild.number}.txt"
    },
    {
      "pattern": "acme-1.${currentBuild.number}.tgz",
      "target": "sal-gradle-sandbox-local/com/acme/1.${currentBuild.number}/acme-1.${currentBuild.number}.tgz"
    }
  ]
}"""
server.upload spec: uploadSpec, buildInfo: buildInfo
server.publishBuildInfo buildInfo
    }
    stage('Download') {
        deleteDir() //Deletes the entire workspace, so we rely 100% on Artifactory
        // PART 2 - Add download spec here and download "acme.txt" and "acme.tgz" from Artifactory
        def downloadSpecPattern = """{
  "files": [
    {
      "pattern": "sal-gradle-sandbox-local/com/acme/1.${currentBuild.number}/*.*",
      "flat": true
    }
  ]
}"""
server.download spec: downloadSpecPattern, buildInfo: buildInfo
        archiveArtifacts '**/*.*'
    }
    stage ('Automatic Promote'){
        def promotionConfig = [
    // Mandatory parameters
    'buildName'          : buildInfo.name,
    'buildNumber'        : buildInfo.number,
    'targetRepo'         : 'sal-gradle-dev-local', //name of the repo to promote the artifacts to
    'status'             : 'Promoted', //Denotion of maturity level for the build.
    'copy'               : false, // Should the artifacts be moved or copied when promoting from one repo to another.

]
// Promote build
server.promote promotionConfig
    }
    stage ('Interactive Promote'){
        // PART 4 - Interactively promote the build to the next level
         def promotionConfig = [
    // Mandatory parameters
    'buildName'          : buildInfo.name,
    'buildNumber'        : buildInfo.number,
    'targetRepo'         : 'sal-gradle-regtest-local', //name of the repo to promote the artifacts to
    'status'             : 'Promoted', //Denotion of maturity level for the build.
    'copy'               : false, // Should the artifacts be moved or copied when promoting from one repo to another.

]
Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig
    }
}
```
