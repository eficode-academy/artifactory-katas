# Artifactory builds in Jenkins

We want to enable the automatic promotion of artifacts through the maturity repositories. As Jenkins is our defacto build server, we will use the provided Artifactory plugin to interact with the artifact manager.

Our goal in this exercise is to simulate a normal workflow in your production environment, but leave out all the nitty gritty details that makes learning hard.

The end result should be a fully functioning pipeline that takes advantage of Artifactory to

* Upload
* Download
* Promote throughout the pipeline

Each of the bullets represents is represented by an exercise below.
In order to do the exercises, you need to setup a job in Jenkins.

> Hint: The goal of this exercise is not to learn Jenkins pipeline syntax, nor groovy, but understanding the options you get in Jenkins. If you get stuck, please refer to the [reference pipeline](./complete_pipeline.md) for help.

## Initial setup

* Go in and make a new pipeline job in Jenkins called `$KATA_USERNAME-pipeline`, by clicking `New Item` --> *Enter the job name* --> `Pipeline` --> `OK` 
* Go into the job and paste the following skeleton into the `pipeline` section

```groovy
node {
     def buildInfo = Artifactory.newBuildInfo()
     buildInfo.env.capture = true
     def server = Artifactory.newServer url: 'http://artifactory_url', username: 'admin', password: 'verySecretPassword'
    stage('Preparation') { // for display purposes
        // This is where you normally checkout your source repository
    }
    stage('Build') {
        // "build" some software
        sh "echo 'this is our "binary"'>build.txt"
    }
    stage('Upload') {
        // PART 1 - Add upload spec here and upload "build.txt" to Artifactory
    }
    stage('Download') {
        deleteDir() //Deletes the entire workspace, so we rely 100% on Artifactory
        // PART 2 - Add download spec here and download "build.txt" from Artifactory
    }
    stage ('Promote'){
        // PART 3 - Promote the build to the next level
    }
}
```

This is our baseline.

> Note: we set the credentials and url of the Artifactory server directly in the jenkins file here which are not considered best practice. Consult the [web docs](https://www.jfrog.com/confluence/display/RTF/Working+With+Pipeline+Jobs+in+Jenkins) for better ways of creating the artifactory connection.

## Part 1: Upload the artifact

In order for you to upload things through the plugin, you need to specify a `File Spec`.
File Specs are JSON objects that are used to specify the details of the files you want to upload or download. 

They consist of a `pattern` and a `target`, and a number of optional properties can be added to them.

> Note: The filespec has a lot of options you can work with. For more in depth information, consult the [web docs](https://www.jfrog.com/confluence/display/RTF/Using+File+Specs).

This is the basic structure of an upload spec:

```misc
{
  "files": [
    {
      "pattern": "[Mandatory]",
      "target": "[Mandatory]",
      "props": "[Optional]", // Properties that will be set to all artifacts uploaded to artifactory
      "recursive": "[Optional, Default: 'true']",
      "flat" : "[Optional, Default: 'true']",
      "regexp": "[Optional, Default: 'false']",
      "explode": "[Optional, Default: false]",
      "excludePatterns": ["[Optional]"]
    }
  ]
}
```

In a Jenkins pipeline, you can define an upload spec as a multi-line string:

```groovy
def uploadSpec = """{
  "files": [
    {
      "pattern": "yourPatternGoesHere",
      "target": "yourTargetGoesHere"
    }
  ]
}"""
```

Once you have your upload spec, you can trigger the upload within the pipeline with the following line:

```groovy
server.upload spec: uploadSpec, buildInfo: buildInfo
```

In order for us to upload a file, we need to define two things; `pattern` and `target`

* `pattern` Specifies the local file system path to artifacts which should be uploaded to Artifactory. You can specify multiple artifacts by using wildcards or a regular expression as designated by the regexp property. If you use a regexp, you need to escape any reserved characters (such as ".", "?", etc.) used in the expression using a backslash "\\".
* `target` Specifies the target path in Artifactory in the following format: [repository_name]/[repository_path]

### Tasks

* in the `upload` step of your jenkins file, make an upload spec that takes the `build.txt` and uploads it to the `Maturity level 1` repo under `com/acme/1.${currentBuild.number}/build-1.${currentBuild.number}.txt`
* go into artifactory UI and look at the corresponding file being uploaded into the correct repository and directory.

> hint: the `${currentBuild.number}` is a Jenkins variable for accessing the build number.

## Part 2: Download the artifact

When we need to download artifacts, we can use File Specs again:

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

There are two key differences to notice:

* You can use `aql` to search for artifacts as well as the normal pattern based search.
* The `props` attribute is no longer used for setting properties, but as a filter for only downloading the ones where the given property is set.

### Tasks

* Modify your pipeline so it downloads the file you just uploaded.
* Check within the pipeline that a folder is made. You could for instance use `sh : "ls"` and look at the console output of the Jenkins job.
* Use the `flat` property to download the file to the root of the workspace, ignoring the repository folder structure.

> Hint: you can either make a search on the specific layout, or use the `@` notation to search for build number and name (details can be found [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-ConstructingSearchCriteria))

## Part 3: Promotion

As your build progresses through the pipeline, your artifacts get promoted to a higher maturity level, and therefore different repository.

Promotion has a different JSON structure than uploading and downloading. Here you can see an example of a promotion structure, defined as a map in a Jenkins pipeline:

```groovy
def promotionConfig = [
    // Mandatory parameters
    'buildName'          : buildInfo.name,
    'buildNumber'        : buildInfo.number,
    'targetRepo'         : '', //name of the repo to promote the artifacts to

    // Optional parameters
    'comment'            : '', //Comment that will be seen on the build entity
    'sourceRepo'         : '', //name of the repo to promote the artifacts from
    'status'             : '', //Denotion of maturity level for the build.
    'includeDependencies': true, // If your artifact has any dependencies, should they be promoted as well?
    'copy'               : true, // Should the artifacts be moved or copied when promoting from one repo to another.
    // 'failFast' is true by default.
    // Set it to false, if you don't want the promotion to abort upon receiving the first error.
    'failFast'           : true
]
// Promote build
server.promote promotionConfig
```

### Tasks

* In the `promote` stage of your pipeline, make a promotion config that copies the artifacts from `Maturity level 1` to `Maturity level 2` repository.
* Execute the pipeline to check that the artifacts gets copied over.
* Make a new stage `interactive promote`
* In that stage make a promotionConfig that promotes the artifacts from `Maturity level 2` to `Maturity level 3` repository.
* Instead of making an automated promotion, replace `server.promote promotionConfig` with `Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig` to make an interactive promotion.
* Observe in Artifactory that `Maturity level 2` has the artifact, and `Maturity level 3` does not yet have them.
* Go back into the jenkins Ui and click "promote" to promote the artifact.
* Observe in Artifactory that `Maturity level 3` has the artifact now as well.

## FAQ

* Q: I have multiple stages that I want to upload artifacts from, but I can only do one upload per build.
  * A: You have two options: make several builds and loose traceability between them, or wait with uploading till all artifacts have been produced limiting the measurement of maturity progression.
* Q: Should I move or copy my artifacts when i promote?
  * A: Artifactory prefer to make virtual repositories spanning several local ones to copy. Remember that if you copy, then the properties are not propagated to the other instances of the same artifact.
* Q: while promoting the build, I want to append new properties to the artifacts.
  * A: Unfortunately you cannot do that via the plugin. The rest API on the other hand have that capability, so please look at our [curl promotion](.promote_curl.md)