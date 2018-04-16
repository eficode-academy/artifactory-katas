
### Resulting pipeline

```groovy
node {
     def buildInfo = Artifactory.newBuildInfo()
     buildInfo.env.capture = true
     buildInfo.retention maxBuilds: 2, deleteBuildArtifacts: true
     def server = Artifactory.newServer url: 'http://ec2-18-197-71-5.eu-central-1.compute.amazonaws.com:8081/artifactory', username: 'admin', password: 'orange'
    stage('Preparation') { // for display purposes
        // Get some code from a git repository
    }
    stage('Build') {
        // Run the maven build
        sh "echo 'hej'>build.txt"
        sh "ls"

    }
    stage('Upload') {
        buildNumber = currentBuild.number;
        def uploadSpec = """{
            "files": [
            {
           "pattern": "build.txt",
            "target": "sal-generic-gradle-1/org/module/1.${buildNumber}/module-1.${buildNumber}.txt"
                , "props": "hej=hej"
            }
            ]
            }"""
            echo "before buildInfo"
        server.upload spec: uploadSpec, buildInfo: buildInfo
        echo "after buildInfo"
        server.publishBuildInfo buildInfo
    }
    stage('Download') {
    deleteDir() //Deletes the entire workspace, so we rely 100% on artifactory
    def downloadSpec= """{
  "files": [
    {
     "aql": {
        "items.find":{
                "repo": "sal-generic-gradle-1",
                "@build.name":"jenkins-artifactory-plugin",
                "@build.number":"13"
                }
    },
    "flat":"true"
   }
  ]
}"""
server.download spec: downloadSpec, buildInfo: buildInfo
sh 'ls'
    }

    stage ('promote'){
        def promotionConfig = [
        //Mandatory parameters
        'buildName'          : buildInfo.name,
        'buildNumber'        : buildInfo.number,
        'targetRepo'         : 'sal-generic-gradle-2',

        //Optional parameters
        'comment'            : 'this is the promotion comment',
        'status'             : 'Released',
        'includeDependencies': true,
        'failFast'           : true,
        'copy'               : true
    ]

    // Promote build
server.promote promotionConfig
//Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig, displayName: "Promote me please"
    }
      stage ('promote again'){
        def promotionConfig = [
        //Mandatory parameters
        'buildName'          : buildInfo.name,
        'buildNumber'        : buildInfo.number,
        'targetRepo'         : 'sal-generic-gradle-3',

        //Optional parameters
        'comment'            : 'this is the promotion comment',
        'sourceRepo'         : 'sal-generic-gradle-2',
        'status'             : 'Released',
        'includeDependencies': true,
        'failFast'           : true,
        'copy'               : true
    ]

    // Promote build
Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig
    }
        stage ('dance'){
            echo 'hep hey'
        }

}
```