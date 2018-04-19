# Creating Artifactory builds with Gradle

The Artifactory plugin for Gradle allows you to create builds as part of the upload process.

The `exercise` folder has been set up to mimick the end state of the `gradle_remote_and_artifactory_plugin` exercise, with an additional file added. It contains a filled out `build.gradle` with artifactory publishing configured. Currently if you call `gradle artifactoryPublish`, `Duck.jpg` and `Moose.jpg` will be downloaded as dependencies and turned into the artifacts `Duck.zip` and `Moose.zip`. These artifacts will then be published to Artifactory, to the `$KATA_USER-gradle-dev-local` repository.

The Artifactory plugin for Gradle automatically creates a build, but it is lacking some information.

The goal of this exercise is to add some more information to the build. We will add some properties to the artifacts, give our build a name and number and make sure that environment variables are published. Finally, we will look at how to promote artifacts through the REST API.

Everything in this exercise is well documented on [the Gradle Artifactory Plugin website](https://www.jfrog.com/confluence/display/RTF/Gradle+Artifactory+Plugin#GradleArtifactoryPlugin-Configuration). It is worth consulting if you plan on using the plugin, as it shows all the possibilities.

## Exercise

- Add a property `'animalType':'land_animal'` to artifacts in the build

    **Hint:** Properties for all artifacts are added in `build.gradle` under `artifactory -> publish -> defaults`, and is formatted like this: 
    ```groovy
    properties = ['qa.level': 'basic', 'q.os': 'win32, deb, osx']
    ```
- Run `gradle artifactoryPublish` and check that your newly published artifacts have the new property.
- Add a property `'animal':'duck'` to all items in `duckPublication`, and `'animal':'moose'` to all items in `moosePublication`

    **Hint:** Properties for specific groups of artifacts are made with a closure in `build.gradle` under `artifactory -> publish -> defaults`:
    ```groovy 
    properties {
        publicationName '*:*:*:*@*','propertyKey1':'propertyValue1', 'propertyKey2':'propertyValue2'
    }
    ```
- Run `gradle artifactoryPublish` and check that your newly published artifacts have the new property.
- Set the build name and build number to something fitting or something funny.

    **Hint:** The properties are set in `build.gradle` in the `artifactory` closure. The variables are called
    ```groovy
    clientConfig.info.setBuildName('name')
    clientConfig.info.setBuildNumber('number') //Yes, the build number is a string
    ```
- Include environment variables in the build info.

    **Hint:** This is done in `build.gradle` in the `artifactory` closure:
    ```groovy
    clientConfig.setIncludeEnvVars(true)
    ```
- Promote your build from `$KATA_USER-gradle-dev-local` to `$KATA_USER-gradle-release-local`. 

    **Hint:** Use the `PromoteBuild` task at the bottom of `build.gradle`. You will need to fill out `myBuildName` and `myBuildNumber` with the names you decided in the previous step. Then you can call `gradle PromoteBuild` in your commandline

    **Info:** If you have done the `promote_curl` exercise, you can take a look at `promote_build_query.json` in the exercise folder. This is the query we send to Artifactory in order to do the promotion, and it follows the same spec discussed in the previous exercise.

    **Info:** In a real setup, you should use an http library to create your queries instead of relying on external tools like curl, but since this is not a Groovy course, we do not want to spend any time pulling in 3rd party libraries and learning different syntax.
- Go to the Artifactory UI, find `$KATA_USERNAME-gradle-release-local` and check that the files have been copied over.

You have now added properties, set name/number of your build and succesfully promoted the files to a different maturity level. 