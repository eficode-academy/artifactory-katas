# Gradle repositories

## Introduction to Gradle repositories
By now you are familiar with Artifactory repositories, and how to manually upload and download files. Manually downloading files won't really do when developing software. For that we need some proper dependency management, and Gradle is the perfect candidate.

A repository has been set up for you. The name is printed in your terminal when you run `setup.sh`, and can also be found in `build.gradle`. The repository follows the standard Gradle layout, and it contains a single file. We'd like to use this file as a dependency in our program.

## Resolving and downloading dependencies with Gradle

**Exercise**
1. Visit Artifactory and find the file. Modify your `build.gradle` so that the file is added as a dependency.

    **Hint:** If you visit your artifact in the Artifactory UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.
1. Run `gradle dependencies` and make sure that the file resolves.

## Create remote repo and apply the Artifactory Gradle plugin
Before we continue to the logical next step, uploading, we need to get access to the Artifactory Plugin for Gradle. Since this plugin is accessible on the internet via jcenter, this is a perfect opportunity to create a remote repository in Artifactory to proxy jcenter.

1. Create a remote repository with the Artifactory UI. Name it `jcenter-remote-repo-$USERNAME` so it's unique to you and can be deleted afterwards. It should be of package type `Gradle` and should proxy `https://jcenter.bintray.com`
1. Add the plugin declaration as shown in the documentation for the [Artifactory plugin](), but replace `jcenter()` with your own remote repo.

    **Hint:** This is how the top of your `build.gradle` file should look:

    ```gradle
    buildscript {
        repositories {
            maven { url "http://ec2-18-197-71-5.eu-central-1.compute.amazonaws.com:8081/artifactory/jcenter-remote-repo-$USERNAME" }
        }
        dependencies {
            classpath "org.jfrog.buildinfo:build-info-extractor-gradle:latest.release"
        }
    }
    apply plugin: "com.jfrog.artifactory"´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´
    [...]
    ```
1. Run `gradle dependencies` to verify that everything still resolves as it should. 

## Uploading to a Gradle repository
Now that we can succesfully resolve our dependency, and have the Artifactory plugin set up, let's produce something that can be uploaded to Artifactory. 

1. Run `gradle productZip`. As you can see from `build.gradle` this task takes our dependency and zips it up. Verify that you have a file called `Duck.zip`
1. 




1. Make your own local Artifactory repository that can resolve to Gradle. Give it the name that was printed in your terminal when you ran `setup.sh`

    **Hint:** You can use the default Gradle-layout for your repository, or you can make your own custom layout. As long as it contains `[org]`, `[module]`, `[baseRev]` and `[ext]`, Artifactory will be able to serve it as a Gradle dependency.


- Create a Gradle repository in the Artifactory UI. The output of `setup.sh` will tell you what to call it.
- Upload `Duck.jpg` through the UI, following the repository layout.
- Modify `build.gradle` so `groupId:artifactId:version` matches your artifact.
  
  **Hint:** If you visit your artifact in the Gradle UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.
- Run `gradle dependencies` and check that your artifact resolves.