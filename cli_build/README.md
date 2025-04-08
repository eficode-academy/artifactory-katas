# Artifactory builds through the JFrog CLI

**Introduction:**

Welcome! This exercise will guide you through using the powerful **JFrog CLI** to interact with builds in **Artifactory**. The JFrog CLI is a crucial tool for automating your CI/CD processes.

You'll learn how to:

* Upload a file and link it directly to a specific build.
* Add important environment details to your build information.
* Publish your build information so it's visible and trackable in Artifactory.
* Promote a build from one repository to another, simulating a common step in a release workflow.

We'll be simulating the lifecycle of a simple build. For detailed command options and further exploration, feel free to consult the official [JFrog CLI documentation](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).

In this kata we'll learn a few ways to interact with Artifactory builds.

## JFrog CLI usage

To link artifacts to a build, upload them with `--build-name` and `--build-number` arguments added.

To include environment information, run `jf rt bce` (or `jf rt build-collect-env`), supplying the relevant build name and number.

To publish a build to Artifactory, run `jf rt bp` (or `jf rt build-publish`), supplying the relevant build name and number.

To promote a build, run `jf rt bpr` (or `jf rt build-promote`), supplying the relevant build name, number and target repository.

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
