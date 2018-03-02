
## Creating an Artifactory Server Instance
 Manage | Configure System.

* Build
* Spec
    * Upload
    * Download
    * properties
* Promotion

```groovy
node {
     def buildInfo = Artifactory.newBuildInfo()
     def server = Artifactory.newServer url: 'http://nginx/artifactory', username: 'admin', password: 'lkvmxxcv'
    stage('Preparation') { // for display purposes
        // Get some code from a GitHub repository
    }
    stage('Build') {
        // Run the maven build
        sh "echo 'hej'>build.txt"
        sh "ls"

    }
    stage('Upload') {
        def uploadSpec = """{
            "files": [
            {
           "pattern": "build.txt",
            "target": "artifactory_katas-sal/org/module/1.4/module-1.4.txt"
            }
            ]
            }"""
            echo "before buildInfo"
        server.upload spec: uploadSpec, buildInfo: buildInfo
        echo "after buildInfo"
        server.publishBuildInfo buildInfo
    }

    stage ('promote'){
        def promotionConfig = [
        //Mandatory parameters
        'buildName'          : buildInfo.name,
        'buildNumber'        : buildInfo.number,
        'targetRepo'         : 'artifactory_katas-sal2',

        //Optional parameters
        'comment'            : 'this is the promotion comment',
        'status'             : 'Released',
        'includeDependencies': true,
        'failFast'           : true,
        'copy'               : true
    ]

    // Promote build
server.promote promotionConfig
    }

}
```