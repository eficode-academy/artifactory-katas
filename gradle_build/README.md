# Creating Artifactory builds with Gradle

The Artifactory plugin for Gradle allows you to create builds as part of the upload process.

The `exercise` folder has been set up to mimick the end state of the `gradle_remote_and_artifactory_plugin` exercise, with an additional file added. It contains a filled out `build.gradle` with artifactory publishing configured. Currently if you call `gradle artifactoryPublish`, `Duck.jpg` and `Moose.jpg` will be downloaded as dependencies and turned into the artifacts `Duck.zip` and `Moose.zip`. These artifacts will then be published to Artifactory.

The Artifactory plugin for Gradle automatically creates a build, but it is lacking some information.

The goal of this exercise is to add some more information to the build. We will add some properties to the artifacts, give our build a name and number and make sure that environment variables are published.

Everything in this exercise is well documented on [the JFrog website](https://www.jfrog.com/confluence/display/RTF/Gradle+Artifactory+Plugin#GradleArtifactoryPlugin-Configuration). It is worth consulting if you plan on using the plugin, as it shows all the possibilities.

## Exercise

1. Add a property `'animalType':'land_animal'` to artifacts in the build

    **Hint:** Properties for all artifacts are added in `build.gradle` under `defaults`, and is formatted like this: 
    ```groovy
    properties = ['qa.level': 'basic', 'q.os': 'win32, deb, osx']
    ```
2. Add a property `'animal':'duck'` to all items in `duckPublication`, and `'animal':'moose'` to all items in `moosePublication`

    **Hint:** Properties for specific groups of artifacts are made with a closure in `build.gradle` under `defaults`:
    ```groovy 
    properties {
        publicationName 'propertyKey1':'propertyValue1', 'propertyKey2':'propertyValue2'
    }
    ```
3. Set the build name to something fitting and the build number to something funny.

    **Hint:** The properties are set in `build.gradle` in the `artifactory` closure. The variables are called
    ```groovy
    clientConfig.info.setBuildName('name')
    clientConfig.info.setBuildNumber('number') //Yes, the build number is a string
    ```
4. Include environment variables in the build info.

    **Hint:** This is done in `build.gradle` in the `artifactory` closure:
    ```groovy
    clientConfig.setIncludeEnvVars(true)
    ```