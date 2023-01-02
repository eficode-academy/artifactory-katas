# Artifactory builds in Gitlab

We want to enable the automatic promotion of artifacts through the maturity repositories. 

Our goal in this exercise is to simulate a normal workflow between Artifactory and Gitlab in your production environment, but leave out all the nitty gritty details that makes learning hard.

The end result should be a fully functioning pipeline that takes advantage of Artifactory to:

* Upload
* Download
* Promote throughout the pipeline

Each of the bullets is represented by an exercise below.
In order to do the exercises, you need to setup a repository and CI job in Gitlab.

> :bulb: The goal of this exercise is not to learn Gitlab pipeline syntax, but understanding the options you get in Gitlab. If you get stuck, please refer to the [reference pipeline](./complete_pipeline.yaml) for help.

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
* Under settings -> CI/CD add the follwing environment variables:
  * `$ARTIFACTORY_URL`
  * `$ARTIFACTORY_USER`
  * `$ARTIFACTORY_PASS`
  * :bulb: All three values have been printed when you executed the setup script.
* Click `setup CI/CD` and `configure pipeline`
* Paste the following pipeline in as your starter pipeline

```yaml
image:
  name: ruby:3.0
before_script:
  # Install JFrog CLI
  -  curl -fL https://getcli.jfrog.io | sh
  # Configure Artifactory instance with JFrog CLI
  - ./jfrog config add --artifactory-url=$ARTIFACTORY_URL --user=$ARTIFACTORY_USER --password=$ARTIFACTORY_PASS
  # Output the config for debug purposes
  - ./jfrog c show
  # Ping Artifactory to see if the connection is valid.
  - ./jfrog rt ping
  # Set the build URL for the builds in artifactory
  - JFROG_CLI_BUILD_URL=$CI_JOB_URL
stages:          # List of stages for jobs, and their order of execution
  - build
  - test
  - promotion
  - deploy

build-upload-job:       # This job runs in the build stage, which runs first.
  stage: build
  script:
    - echo "$JFROG_CLI_BUILD_URL"
    # Create the artifact to upload and promote
    - echo "this is our artifact from 1.${CI_PIPELINE_IID}" > "artifact-1.${CI_PIPELINE_IID}.txt"
    #Create the filespec needed for upload here
    
    - ls -la #List the artifacts in the log to see if the file is present
    # upload the artifact
    
    # Collect the environment variables
    
    # Submit the build information to Artifactory
    

download-job:   # This job runs in the test stage.
  stage: test    # It only starts when the job in the build stage completes successfully.
  script:
    # download the artifact
    
    #List the different folders
    - ls -la


build-promotion:   # This job also runs in the test stage.
  stage: promotion    # It can run at the same time as unit-test-job (in parallel).
  script:
    # Promote (and therefore move) the build from sandbox to dev
    
    - echo "promoted"
    - sleep 60
deploy:   # This job also runs in the test stage.
  stage: deploy    # It can run at the same time as unit-test-job (in parallel).
  script:
    # Promote (and therefore move) the build from sandbox to dev
    

    - echo "deployed"


```

* Trigger a build and see that the jfrog ping is giving an OK.

This is our baseline.


## Part 1: Upload the artifact

In order for you to upload/download artifacts through the cli, you have two options:

* Via CLI with two arguments: `source` and `target` like `jf rt u "build/*.zip" my-local-repo/zipFiles/`
* Via a `File Spec`.

File Specs are JSON objects that are used to specify the details of the files you want to upload or download. File Specs are prefered over CLI in terms of readability when you are appending more and more arugments to your upload.

They consist of a `pattern` and a `target`, and a number of optional properties can be added to them.

> Note: The filespec has a lot of options you can work with. For more in depth information, consult the [web docs](https://www.jfrog.com/confluence/display/RTF/Using+File+Specs).

<details>
<summary>:bulb: This is the basic structure of an upload spec:</summary>

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
</details>

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
* `target` Specifies the target path in Artifactory. In gradle, the format is: `[repository_name]/[org]/[module]/[revision]/[module]-[revision].[ext]`

:bulb: You can _only_ call upload once during a build which means it should be called after the last artifact have been produced.

Once you have your upload spec, you can trigger the upload within the pipeline with the following line:

```yaml
    - ./jfrog rt u --spec uploadspec.json  --build-name ${CI_PROJECT_TITLE} --build-number ${CI_PIPELINE_IID}
    # Collect the environment variables
    - ./jfrog rt bce ${CI_PROJECT_TITLE} $CI_PIPELINE_IID
    # Pass the build information to Artifactory
    - ./jfrog rt bp ${CI_PROJECT_TITLE} $CI_PIPELINE_IID  
```

### Tasks

* in the `build-upload-job` step of your gitlab file, make an upload spec that takes the `artifact.txt` and uploads it to the `${KATA_USERNAME}-gradle-sandbox-local` repo under `acme/artifact/1.${CI_PIPELINE_IID}/artifact-1.${CI_PIPELINE_IID}.txt`
* click save and run the pipeline by clicking `Commit changes`
* In Artifactory, navigate to the `builds` tab and click on the build to see the list of artifacts (currently only one).

> :bulb: Be aware of the `${CI_PROJECT_TITLE} $CI_PIPELINE_IID ` are Gitlab variables for accessing the build number and project name.

## Part 2: Download the artifact

In downloading the artifacts, we will try to reference the build in order for us to get all artifacts associated with the build itself.

We do that by adding the parameter `--build` to our download command like below:

`./jfrog rt download --build ${CI_PROJECT_TITLE}/$CI_PIPELINE_IID`

### Tasks

* Configure your pipeline so it downloads the file you just uploaded in the `download-job` stage.
* Check within the pipeline that a folder is made. You could for instance use `- ls -la` and look at the console output of the Gitlab job.
* run the job and check the logs to see that the folders are made
* Use the `--flat` parameter to download the file to the root of the workspace, ignoring the repository folder structure.
* run the job again and check the logs to see that the artifact is now in the root of the folder

## Part 3: Promotion

As your build progresses through the pipeline, your artifacts get promoted to a higher maturity level, and therefore different repository.

Promotion is made simple in the JFrog CLI; just reference the build name and number, and the target repository to where the artifacts should be moved to:

 `- ./jfrog rt bpr ${CI_PROJECT_TITLE} $CI_PIPELINE_IID <target repository>`

### Tasks

* In the `build-promotion` stage of your pipeline, make a promotion that moves the artifacts from `${KATA_USERNAME}-gradle-sandbox-local` to `${KATA_USERNAME}-gradle-dev-local` repository with the `status` set to `promoted to dev`
* Execute the pipeline
* Click on the Artifactory icon and check that the artifacts gets moved over
* Under the `Diff` tab in the build browser, choose a prior successful build in the `Select A Build To Compare Against:` section and observe the changes.
* Under the `Release History` tab in the build browser, notice that you have an entry called `promoted to dev`

### Part 4: Last promotion

This part is just a repitition of the prior step, just to illustrate that a promotion can happen sevelral times througout your pipeline untill it is deployed to production.

### Tasks

* In the `build-promotion` stage of your pipeline, add a `- sleep 60` so there is a bit of delay between the two stages.
* In the `deploy` stage, promote the build to `${KATA_USERNAME}-gradle-release-local` with the status `promoted-to-release`
* Commit and trigger the pipeline and observe the promotion to release folder in Artifactory.

## FAQ

* Q: I have multiple stages that I want to upload artifacts from, but I can only do one upload per build.
  * A: You have two options: make several builds and loose traceability between them, or wait with uploading till all artifacts have been produced limiting the measurement of maturity progression.
* Q: Should I move or copy my artifacts when i promote?
  * A: Artifactory prefer move and then make virtual repositories spanning several local ones, than to copy. Remember that if you copy, then the properties are not propagated to the other instances of the same artifact.
* Q: while promoting the build, I want to append new properties to the artifacts.
  * A: The jfrog cli can do this, for more information, look at this [link](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-PromotingaBuild)
