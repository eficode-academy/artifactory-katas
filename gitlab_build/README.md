# Artifactory builds in Gitlab

We want to enable the automatic promotion of artifacts through the maturity repositories. 

Our goal in this exercise is to simulate a normal workflow between Artifactory and Gitlab in your production environment, but leave out all the nitty gritty details that makes learning hard.

The end result should be a fully functioning pipeline that takes advantage of Artifactory to:

* Upload
* Download
* Promote throughout the pipeline

Each of the bullets is represented by an exercise below.
In order to do the exercises, you need to setup a repository and CI job in Gitlab.

> Hint: The goal of this exercise is not to learn Gitlab pipeline syntax, but understanding the options you get in Gitlab. If you get stuck, please refer to the [reference pipeline](./complete_pipeline.yaml) for help.

If you at any point need to look at the documentation for the CLI tool, then here is the [link](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).

## Initial setup of Artifactory

* Go to your bash command line
* `cd gitlab-build`
* `./setup.sh`

This will create the following repositories (and maturity levels):

level 1: `${KATA_USERNAME}-gradle-sandbox-local`
level 2: `${KATA_USERNAME}-gradle-dev-local`
level 3: `${KATA_USERNAME}-gradle-regtest-local`
level 4: `${KATA_USERNAME}-gradle-release-local`

## Initial setup of Gitlab

* Go to https://gitlab.com/projects/new and create a new blank repository 
  * Make it public and initialized with a readme file
* Click `setup CI/CD` and `configure pipeline`
* Paste the following pipeline in as your starter pipeline

```yaml
before_script:
  # Install JFrog CLI
  -  curl -fL https://getcli.jfrog.io | sh
  # Configure Artifactory instance with JFrog CLI
  - ./jfrog config add --artifactory-url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASS
  - ./jfrog c show
  - ./jfrog rt ping
stages:          # List of stages for jobs, and their order of execution
  - build
  - test
  - promotion

build-upload-job:       # This job runs in the build stage, which runs first.
  stage: build
  script:
    - echo "this is our artifact from 1.${CI_PIPELINE_IID}" > "artifact-1.${CI_PIPELINE_IID}.txt"
    - |
     echo "{
      \"files\": [
      {
      \"pattern\": \"artifact-1.${CI_PIPELINE_IID}.txt\",
      \"target\": \"sal-gradle-sandbox-local/acme/artifact/1.${CI_PIPELINE_IID}/artifact-1.${CI_PIPELINE_IID}.txt\"
            }
            ]
        }" > uploadspec.json
    - ls -la #List the artifacts in the log to see if the file is present
    - ./jfrog rt u --spec uploadspec.json  --build-name ${CI_PROJECT_TITLE} --build-number ${CI_PIPELINE_IID}
    # Collect the environment variables
    - ./jfrog rt bce ${CI_PROJECT_TITLE} $CI_PIPELINE_IID
    # Pass the build information to Artifactory
    - ./jfrog rt bp ${CI_PROJECT_TITLE} $CI_PIPELINE_IID    

download-job:   # This job runs in the test stage.
  stage: test    # It only starts when the job in the build stage completes successfully.
  script:
    - ./jfrog rt download --build ${CI_PROJECT_TITLE}/$CI_PIPELINE_IID
    - ls -la
    - ls -la acme
    - ls -la acme/artifact


build-promotion:   # This job also runs in the test stage.
  stage: promotion    # It can run at the same time as unit-test-job (in parallel).
  script:
    - echo "Linting code... This will take about 10 seconds."
    #- sleep 10
    - ./jfrog rt bpr ${CI_PROJECT_TITLE} $CI_PIPELINE_IID sal-gradle-dev-local --status promoted to dev


```

* Under settings -> CI/CD add the follwing environment variables:
  * `$ARTIFACTORY_URL`
  * `$ARTIFACTORY_USER`
  * `$ARTIFACTORY_PASS`
* All three values have been printed when you executed the setup script.
* Create a build and see that the jfrog ping is giving an OK.

This is our baseline.


## Part 1: Upload the artifact

In order for you to upload/download artifacts through the cli, you need to specify a `File Spec`.
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

In Gitlab CI, you can define an upload `File Spec` as a multi-line string:

```yaml
    - |
     echo "{
      \"files\": [
      {
      \"pattern\": \"artifact-1.${CI_PIPELINE_IID}.txt\",
      \"target\": \"sal-gradle-sandbox-local/acme/artifact/1.${CI_PIPELINE_IID}/artifact-1.${CI_PIPELINE_IID}.txt\"
            }
            ]
        }" > uploadspec.json
```

In order for us to upload files, we need to define two things; `pattern` and `target`. There can be more files in the defined array.

* `pattern` Specifies the local file system path to artifacts which should be uploaded to Artifactory. You can specify multiple artifacts by using wildcards or a regular expression as designated by the regexp property. If you use a regexp, you need to escape any reserved characters (such as ".", "?", etc.) used in the expression using a backslash "\\".
* `target` Specifies the target path in Artifactory in the following format: [repository_name]/[org]/[module]/[revision]/[module]-[revision].[ext]
* `buildInfo` object is being _filled_ with information several times during the pipeline execution (env.capture, upload and download), but it must be `published` to Artifactory explicitly.

It can _only_ be called once during a Jenkins build which means it should be called after the last `upload`/`download` call.

Once you have your upload spec, you can trigger the upload within the pipeline with the following line:

```yaml
    - ./jfrog rt u --spec uploadspec.json  --build-name ${CI_PROJECT_TITLE} --build-number ${CI_PIPELINE_IID}
    # Collect the environment variables
    - ./jfrog rt bce ${CI_PROJECT_TITLE} $CI_PIPELINE_IID
    # Pass the build information to Artifactory
    - ./jfrog rt bp ${CI_PROJECT_TITLE} $CI_PIPELINE_IID  
```

### Tasks

* in the `upload` step of your gitlab file, make an upload spec that takes the `artifact.txt` and uploads it to the `${KATA_USERNAME}-gradle-sandbox-local` repo under `acme/artifact/1.${currentBuild.number}/artifact-1.${currentBuild.number}.txt`
* click save and run the pipeline by clicking `Commit changes`
* In Artifactory, navigate to the `builds` tab and click on the build to see the list of artifacts (currently only one).

> **Note 1:** Be aware of the `${CI_PROJECT_TITLE} $CI_PIPELINE_IID ` are Gitlab variables for accessing the build number and project name.

## Part 2: Download the artifact

When we need to download artifacts, we can use File Specs again:

```text
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

* You can use `aql` to search for artifacts like the one below:

> **Note:** If you are running our course, then AQL has not been introduced before. Just keep in mind that this is possible.

```json
   "aql": {
        "items.find": {
            "@build.name": { "\$eq":"${JOB_NAME}" },
            "@build.number": { "\$eq":"${currentBuild.number}" }
        }
```

* You can use `pattern` which target files using their layout like below:

```
      "pattern": "<repo>/<module>/<revision>/*.*"
```

* The `props` attribute is no longer used for setting properties, but as a filter for only downloading the ones where the given property is set.

Now all you need is downloading it through: `server.download spec: downloadSpec, buildInfo: buildInfo`

### Tasks

* Configure your pipeline so it downloads the file you just uploaded.
* Check within the pipeline that a folder is made. You could for instance use `sh "ls -la"` and look at the console output of the Jenkins job.
* run the job and check the logs to see that the folders are made
* Use the `flat` property to download the file to the root of the workspace, ignoring the repository folder structure.
* run the job again and check the logs to see that the artifact is now in the root of the folder

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
    // Set it to false, if you don't want the promotion to abort upon receiving the first error.
    'failFast'           : true // 'failFast' is true by default.
  ]
  // Promote build
  server.promote promotionConfig
```

### Tasks

* In the `Automatic Promote` stage of your pipeline, make a promotion config that moves the artifacts from `Maturity level 1 (${KATA_USERNAME}-gradle-sandbox-local)` to `Maturity level 2 ${KATA_USERNAME}-gradle-dev-local)` repository with the `status` set to `promoted to dev`
* Execute the pipeline
* Click on the Artifactory icon and check that the artifacts gets moved over
* Under the `Diff` tab in the build browser, choose a prior successful build in the `Select A Build To Compare Against:` section and observe the changes.
* Under the `Release History` tab in the build browser, notice that you have an entry called `promoted to dev`

### Part 4: Interactive promotion

As we saw in part 3, we can promote artifacts automatically during the build execution. It is also possible to make a decision later and do the promotion interactively - even when the build has completed.

### Tasks

* In that stage `Interactive promote` make a promotionConfig that promotes the artifacts from `Maturity level 2 (${KATA_USERNAME}-gradle-dev-local)` to `Maturity level 3 (${KATA_USERNAME}-gradle-regtest-local)` repository.
* Instead of making an automated promotion using `server.promote promotionConfig`, we now want use `Artifactory.addInteractivePromotion server: server, promotionConfig: promotionConfig` to make an interactive promotion.
* Observe in Artifactory that `Maturity level 2 (${KATA_USERNAME}-gradle-dev-local)` has the artifact, and `Maturity level 3 (${KATA_USERNAME}-gradle-regtest-local)` does not yet have them.
* Go back into the jenkins Ui and click "promote" to promote the artifact.
* Observe in Artifactory that `Maturity level 3 (${KATA_USERNAME}-gradle-regtest-local)` has the artifact now.
* Under the `Release History` tab in the build browser, notice that you have an entry called `promoted to regtest` along the `promoted to dev` status

## FAQ

* Q: I have multiple stages that I want to upload artifacts from, but I can only do one upload per build.
  * A: You have two options: make several builds and loose traceability between them, or wait with uploading till all artifacts have been produced limiting the measurement of maturity progression.
* Q: Should I move or copy my artifacts when i promote?
  * A: Artifactory prefer move and then make virtual repositories spanning several local ones, than to copy. Remember that if you copy, then the properties are not propagated to the other instances of the same artifact.
* Q: while promoting the build, I want to append new properties to the artifacts.
  * A: The jfrog cli can do this, for more information, look at this [link](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-PromotingaBuild)








# Build using JFrog CLI

If you at any point need to look at the documentation for the CLI tool, then here is the [link](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).

## Using the CLI

The CLI span all JFrogs products, and therefore you need to specify what you are calling and then the method.
Take the following command as an example:

``` ./jfrog rt u <your artifacts> <repo path>```

* `rt` stands for a`rt`ifactory
* `u` stands for `u`pload
* `<your artifacts>` is where on your local machine the artifact
* `<repo path>` is the full path on Artifactory where the artifact needs to be uploaded to, like `${KATA_USERNAME}-gradle-dev-local/acme/fox/4.5.0/fox-4.5.0.jpg`.

## Tasks

* run `setup.sh`
* upload the `moose.jpg` image with version 1.0.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo
* upload the `squirrel.jpg` image with version 1.2.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo

Optional tasks

* download everything from the `${KATA_USERNAME}-gradle-dev-local` repo in one command without the folder structure.
* upload `fox.jpg` with version `7.0.0` and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo with the property `'animalType':'land_animal'` set


## Build through the CLI

The CLI also enables you to make builds entities in Artifactory.

The way to do it is

* Upload files with the `--build-name` and `--build-number` arguments added.
* (optional) upload the environment variables with the `bce` command. `bce` stands for build-collect-env.
* publish the build to Artifactory with the `bp` command

## Task

* Think of a build name and build number to use. It can be something fitting or something funny.
* Upload the `moose.jpg` and `squirrel.jpg` image both with version 2.2.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo. Remember to add the build name and number to the uploads.
* Include environment variables to the build.
* Publish your build through the CLI.
* Promote your build from `${KATA_USERNAME}-gradle-dev-local` to `${KATA_USERNAME}-gradle-release-local`. 
* Go to the Artifactory UI, find `${KATA_USERNAME}-gradle-release-local` and check that the files have been copied over.

You have now added properties, set name/number of your build and succesfully promoted the files to a different maturity level through the CLI.