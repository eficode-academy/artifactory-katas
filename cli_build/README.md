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

In this task, we are going to upload an artifact, associate it with a build, and then through the build, promote it to another repo.

1.  **Upload & Link Artifact:**
    ```bash
    jf rt upload fox.jpg soal-gradle-dev-local/acme/2.2.0/fox.jpg --build-name="soal-fox" --build-number=1
    ```
    *(Upload `fox.jpg` to the dev repo, linking it to build `${KATA_USERNAME}-fox`, number `1`)*

2.  **Capture Environment:**
    ```bash
    jf rt bce ${KATA_USERNAME}-fox 1
    ```
    *(Collect environment variables for the build)*

3.  **Publish Build Info:**
    ```bash
    jf rt bp ${KATA_USERNAME}-fox 1
    ```
    *(Publish build information to Artifactory)*

4.  **Verify in UI (Part 1):**
    * In Artifactory UI, navigate to **Builds** > `${KATA_USERNAME}-fox` / `1`.
    * Check **Published Modules** for `fox.jpg`.
    * Check **Environment** for captured variables.

5.  **Promote Build:**
    ```bash
    jf rt bpr ${KATA_USERNAME}-fox 1 ${KATA_USERNAME}-gradle-release-local
    ```
    *(Promote build `${KATA_USERNAME}-fox` / `1` to the release repo)*

6.  **Verify in UI (Part 2):**
    * In Artifactory UI, revisit build `${KATA_USERNAME}-fox` / `1`.
    * Confirm `fox.jpg`'s repository in **Published Modules** is now `${KATA_USERNAME}-gradle-release-local`.
    * Optionally, check the `${KATA_USERNAME}-gradle-release-local` repository in the **Artifacts** browser.

**Success!** You've used the JFrog CLI for artifact upload, build association, publishing, and promotion in Artifactory.