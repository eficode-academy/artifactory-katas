
## Creating an Artifactory Server Instance
 Manage | Configure System.

### setup

* Go in and make a new pipeline job in Jenkins called `jenkins-artifactory-plugin`.
* Go into the job and paste the following skeleton into the pipeline part.

```groovy
node {
     def buildInfo = Artifactory.newBuildInfo()
     buildInfo.env.capture = true
     def server = Artifactory.newServer url: 'http://nginx/artifactory', username: 'admin', password: 'lkvmxxcv'
    stage('Preparation') { // for display purposes
        // Get some code from a GitHub repository
    }
    stage('Build') {
        // "build" some software
        sh "echo 'this is our "binary"'>build.txt"
    }
    stage('Upload') {
        //Upload the artifact to Artifactory
    }
    stage('Download') {
    deleteDir() //Deletes the entire workspace, so we rely 100% on artifactory
    }

    stage ('promote'){
        // Promote the build to the next level
    }

}
```

This is our baseline.

> Hint: we set the credentials and url of the Artifactory server directly in the jenkins file here which are not considered best practice. Consult the [web docs](https://www.jfrog.com/confluence/display/RTF/Working+With+Pipeline+Jobs+in+Jenkins) for better ways of creating the artifactory connection.


### Upload the artifact

File Specs can be used to specify the details of files you want to upload or download to or from Artifactory.

> Hint: The filespec has a lot of options you can work with. For more in depth information, consult the [web docs](https://www.jfrog.com/confluence/display/RTF/Using+File+Specs).

```json
def uploadSpec = """{
  "files": [
    {
      "pattern": "[Mandatory]",
      "target": "[Mandatory]",
      "props": "[Optional]",
      "recursive": "[Optional, Default: 'true']",
      "flat" : "[Optional, Default: 'true']",
      "regexp": "[Optional, Default: 'false']",
      "explode": "[Optional, Default: false]",
      "excludePatterns": ["[Optional]"]
    }
  ]
}"""
```

You upload the specified files with a `server.upload spec: uploadSpec, buildInfo: buildInfo`

In order for us to upload a file, we need to define two things; `pattern` and `target`

* `pattern` Specifies the local file system path to artifacts which should be uploaded to Artifactory. You can specify multiple artifacts by using wildcards or a regular expression as designated by the regexp property. If you use a regexp, you need to escape any reserved characters (such as ".", "?", etc.) used in the expression using a backslash "\".
* `target` Specifies the target path in Artifactory in the following format: [repository_name]/[repository_path]

**tasks:**

* in the `upload` step of your jenkins file, make an upload spec that takes the `build.txt` and uploads it to the `*-generic-gradle-1` repo under `com/acme/1.${currentBuild.number}/build-1.${currentBuild.number}.txt`
* go into artifactory UI and look at the corresponding file being uploaded into the correct repository and directory.

> hint: the `${currentBuild.number}` is a Jenkins variable for accessing the build number.

### Download the artifact

If we need to download artifacts, we can use File Specs again:

```json
{
  "files": [
    {
      "pattern" or "aql": "[Mandatory]",
      "target": "[Optional, Default: ./]",
      "props": "[Optional]",
      "recursive": "[Optional, Default: true]",
      "flat": "[Optional, Default: false]",
      "build": "[Optional]",
      "explode": "[Optional, Default: false]",
      "excludePatterns": ["[Optional]"]
    }
  ]
}
```

There are two key differences to notice

* You can use `aql` to search for artifacts as well as the normal pattern based search.
* The `props` attribute is no longer setting properties, but only downloading the ones where the given property is set.

**tasks:**

* download the file you just made
* make a `sh : "ls"` command in the pipeline to see that a folder is made
* use the `flat` property to download the file to the root of the workspace, ignoring the repository folder structure.

>hint: you can both make a search on the specific layout, or use the `@` notation to search for build number and name 

### Promotion

* Promotion
* downloads, test and upload.

### Properties

* properties

### Resulting pipeline
```groovy
node {
     def buildInfo = Artifactory.newBuildInfo()
     buildInfo.env.capture = true
     def server = Artifactory.newServer url: 'http://ec2-18-197-159-60.eu-central-1.compute.amazonaws.com:8081/artifactory', username: 'admin', password: 'orange'
    stage('Preparation') { // for display purposes
        // Get some code from a GitHub repository
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
            "pattern":"sal-generic-gradle-1/org/module/*/*.txt"
            }
        ]
    }"""
server.download spec: downloadSpec, buildInfo: buildInfo
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
    }

}
```