# Gradle repositories

# THIS IS EXERCISE 1

## Introduction to Gradle repositories
By now you are familiar with Artifactory repositories, and how to manually upload and download files. Manually downloading files won't really do when developing software. For that we need some proper dependency management, and Gradle is the perfect candidate.

A repository has been set up for you. The name is printed in your terminal when you run `setup.sh`, and can also be found in `build.gradle`. The repository follows the standard Gradle layout, and it contains a single file. We'd like to use this file as a dependency in our program.

1. Add your gradle repository to `build.gradle`

    ```groovy
    repositories {
        maven { url "http://ArtifactoryUrl.com:8081/artifactory/$USERNAME-generic-gradle-1" }
    }
    ```
1. Visit Artifactory and find `Duck.jpg` in your repository. Modify your `build.gradle` so that the file is added as a dependency.

    **Hint:** If you visit your artifact in the Artifactory UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.
1. Run `gradle dependencies` and verify that your dependency resolves
1. Run `gradle productZip` and verify that `Duck.zip` is created.
1. Replace `1.0.0` with `1.0.+` and notice how the newest version is automatically resolved

Congratulations, you can now use artifacts from your own repositories as dependencies in groovy!

# THIS IS EXERCISE 2

## Resolving dependencies and pushing artifact with the Artifactory plugin for Gradle
Before we continue to the logical next step, uploading, we need to get access to the Artifactory Plugin for Gradle. Since this plugin is accessible on the internet via jcenter, this is a perfect opportunity to create a remote repository in Artifactory to proxy jcenter.

When we have our remote repository ready, we'll be able to use it in `build.gradle` to find the Artifactory plugin for Gradle. We can then set up what repositories to resolve from, and what repositories to publish to.

1. Create a remote repository with the Artifactory UI. Name it `$USERNAME-jcenter-remote-repo` so it's unique to you and can be deleted afterwards. It should be of package type `Gradle` and should proxy `https://jcenter.bintray.com`
1. Add the plugin declaration and Artifactory configuration to your `build.gradle`

    **Hint:** Artifactory can generate most of the configuration for you. In the UI, visit your repository and click `Set Me Up` in the upper right corner. Type your password to insert your credentials, and then hit `Generate Gradle Settings`. You don't have to change any of the default values.

    - Once you've pasted in the configuration, be sure to change `jcenter()` to your own remote repo. 

        ```groovy
         maven { url "http:/${artifactory_contextUrl}/$USERNAME-jcenter-remote-repo" }
        ```

    - In the Artifactory configuration, change the `resolve` repository from `gradle-dev` to your own repository, `$USERNAME-generic-gradle-1`

    - Remember to also create `gradle.properties` for saving your login credentials. It can be downloaded from the `Set Me Up` page, by clicking `Download gradle.properties`
1. Visit Artifactory and find `Duck.jpg` in your repository. Modify your `build.gradle` so that the file is added as a dependency.

    **Hint:** If you visit your artifact in the Artifactory UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.
1. Run `gradle dependencies` to verify that everything resolves as it should. 
1. Run `gradle productZip`. As you can see from `build.gradle` this task downloads our dependency and zips it up. Verify that you have a file called `Duck.zip`.
1. Run `gradle artifactoryPublish` and check that your artifact was uploaded.