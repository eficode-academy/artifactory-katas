# Artifactory builds through the JFrog CLI

The JFrog CLI enables you to manage builds in Artifactory.

You can:
 - Link artifacts to a build
 - Gather and publish build information
 - Promote builds
 - etc.

In this kata we'll learn a few ways to interact with Artifactory builds.

For help during the exercise, consult the [JFrog CLI documentation](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).


## JFrog CLI usage

To link artifacts to a build, upload them with `--build-name` and `--build-number` arguments added.

To include environment information, run `jfrog rt bce` (or `jfrog rt build-collect-env`), supplying the relevant build name and number.

To publish a build to Artifactory, run `jfrog rt bp` (or `jfrog rt build-publish`), supplying the relevant build name and number.

To promote a build, run `jfrog rt bpr` (or `jfrog rt build-promote`), supplying the relevant build name, number and target repository.

## Task

We'll be simulating the publishing and promotion of the a build.

| Build name | Build Number |
| -----------|--------------|
| ${KATA_USERNAME}-fox | 1  |


* Using the JFrog CLI:
    * Upload the `fox.jpg` file to the `${KATA_USERNAME}-gradle-dev-local` repo under the `acme` organisation as version `2.2.0`. Remember to supply the build name and number.
    * Attach environment information to your build.
    * Publish your build through the CLI.
* Find your build in the Artifactory web UI, confirm the file and environment info are present.
* Using the JFrog CLI:
    * Promote your build from `${KATA_USERNAME}-gradle-dev-local` to `${KATA_USERNAME}-gradle-release-local`. 
* Find your build in the Artifactory web UI, confirm the file location has changed.
