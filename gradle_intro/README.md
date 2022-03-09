# Introduction to Gradle repositories
By now you are familiar with Artifactory repositories, and how to manually upload and download files. Manually downloading files won't really do when developing software. For that we need some proper dependency management, and Gradle is the perfect candidate.

A repository has been set up for you. The name is printed in your terminal when you run `setup.sh`, and can also be found in `build.gradle`. The repository follows the standard Gradle layout, and it contains two versions of `duck.jpg`. We'd like to use this file as a dependency in our program.

Our program is very simple. It takes a given dependency and turns it into a zip file.

The goal of this exercise is to successfully download the latest version of a dependency from Artifactory, and produce an artifact.

## Exercise

1. Navigate to your exercise folder
1. Add your gradle repository to `build.gradle` Go to Artifactory and navigate to your $KATA_USERNAME-generic-gradle-1 repository.
+    Copy URL to file path from the 'General' page

    ```groovy
    repositories {
        maven { url "<Copied from your Artifactory repository General page>" }
    }
    ```
1. Visit Artifactory and find `duck.jpg` in your repository. Modify your `build.gradle` so that the file is added as a dependency.

    **Hint:** If you visit your artifact in the Artifactory UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.

1. Run `gradle dependencies` and verify that your dependency resolves
1. Run `gradle productZip` and verify that `duck.zip` is created.
1. Replace `1.0.0` with `1.0.+` in your dependency declaration.
1. Run `gradle dependencies` again and notice how the newest version is automatically resolved.

    **Hint:** If `1.0.0` is still shown as the newest version, you might have to run `gradle dependencies --refresh-dependencies` to force the cache to refresh

Congratulations, you can now use artifacts from your own repositories as dependencies in gradle!
