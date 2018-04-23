# Resolving dependencies and pushing artifact with the Artifactory plugin for Gradle
In order to start uploading artifacts via Gradle, we need to get access to the Artifactory Plugin for Gradle. Since this plugin is accessible on the internet via jcenter, this is a perfect opportunity to create a remote repository in Artifactory to proxy jcenter.

When we have our remote repository ready, we'll be able to use it in `build.gradle` to find the Artifactory plugin for Gradle. We can then configure what repository to resolve from, and what repository to publish to.

The goal of the exercise is to configure the Artifactory Plugin for Gradle to resolve dependencies from a local gradle repository, use a dependency from this repository to create our own `duck.zip` artifact and finally publish this artifact via Gradle.

## Exercise

1. Create a remote repository with the Artifactory UI. Name it `$USERNAME-jcenter-remote` so it's unique to you and can be deleted afterwards. It should be of package type `Gradle` and should proxy `https://jcenter.bintray.com`
1. Add the plugin declaration and Artifactory configuration to `build.gradle`

    **Hint:** Artifactory can generate most of the configuration for you. In the UI, visit your repository and click `Set Me Up` in the upper right corner. Type your password to insert your credentials, and then hit `Generate Gradle Settings`. You don't have to change any of the default values.

    - Once you've pasted in the configuration, be sure to change `jcenter()` under `buildscripts`->`repositories` to your own remote repo:

        ```groovy
         maven { url "${artifactory_contextUrl}/$USERNAME-jcenter-remote" }
        ```

    - In the Artifactory configuration, change the `repoKey` under both `resolve` -> `repository` and `resolve` -> `repository` to your own repository, `$USERNAME-generic-gradle-1`

    - In `build.gradle`, under `artifactory -> publish`, add the following default, telling the plugin to use the predefined `duckPublication` method:

        ```groovy
        defaults {
            publications ('duckPublication')
        }
        ```

    - Remember to also create `gradle.properties` for saving your login credentials. It can be downloaded from the `Set Me Up` page, by clicking `Download gradle.properties`

The setup script have already inserted our `duck-1.0.0.jpg` dependency in `build.gradle`, so the next exercises have something to handle:

1. Run `gradle dependencies` to verify that everything resolves as it should. 
1. Run `gradle productZip`. As you can see from `build.gradle` this task downloads our dependency and zips it up. Verify that `duck.zip` is created.
1. Run `gradle artifactoryPublish` and check that your zipped artifact `duckzip-1.0.0.zip` was uploaded in your own repository.