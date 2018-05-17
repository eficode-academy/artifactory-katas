# Creating Artifactory builds with Gradle

The Artifactory plugin for Gradle allows you to create builds as part of the upload process.

The `exercise` folder has been set up to use the Artifactory Plugin. It contains a filled out `build.gradle` with the Artifactory Plugin configured. Currently if you call `gradle artifactoryPublish`, `duck.jpg` and `moose.jpg` will be downloaded as dependencies and turned into the artifacts `duck.zip` and `moose.zip`. These artifacts will then be published to Artifactory, to the `$KATA_USER-gradle-dev-local` repository.

The Artifactory plugin for Gradle automatically creates a build, but it is lacking some information.

The goal of this exercise is to add some more information to the build. We will add some properties to the artifacts, give our build a name and number and make sure that environment variables are published. Finally, we will look at how to promote artifacts through the REST API.

Everything in this exercise is well documented on [the Gradle Artifactory Plugin website](https://www.jfrog.com/confluence/display/RTF/Gradle+Artifactory+Plugin#GradleArtifactoryPlugin-Configuration). It is worth consulting if you plan on using the plugin, as it shows all the possibilities.

## Exercise

- If you haven't previously made a remote repository, follow this step and make one now:
    - Create a remote repository with the Artifactory UI. Name it `$USERNAME-jcenter-remote` so it's unique to you. It should be of package type `Gradle` and should proxy `https://jcenter.bintray.com`
- Run `gradle dependencies` to verify that everything resolves as it should. 
- Run `gradle duckZip`. As you can see from `build.gradle` this task downloads our duck dependency and zips it up. Verify that `duck.zip` is created.
- Run `gradle artifactoryPublish` and check that your zipped artifacts `duckzip-1.0.0.zip` and `moosezip-1.0.0.zip` were uploaded in your own repository.

Now that we have confirmed that dependencies are downloaded, zip tasks are working and that files can be published, it's time to add properties and create named builds:
- Add a property `'animalType':'land_animal'` to artifacts in the build

    **Hint:** Properties for all artifacts are added in `build.gradle` under `artifactory -> publish -> defaults`, and is formatted like this: 
    ```groovy
    properties = ['status': 'released', 'isWaterproof': 'inconclusive']
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

    **Info:** If you want to know more about the payload data we send to Artifactory to make a promotion, have a look at [the official documentation](https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API#ArtifactoryRESTAPI-BuildPromotion). The JSON spec shows how it is possible to promote without moving artifacts, and how it can also be used just to add properties to files in a build.

    **Info:** In a real setup, you should use an http library to create your queries instead of relying on external tools like curl, but since this is not a Groovy course, we do not want to spend any time pulling in 3rd party libraries and learning different syntax.
- Go to the Artifactory UI, find `$KATA_USERNAME-gradle-release-local` and check that the files have been copied over.

You have now downloaded dependencies, turned them into zip files, added properties, set name/number of your build and succesfully promoted the files to a different maturity level. 