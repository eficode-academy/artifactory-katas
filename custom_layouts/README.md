# Custom layout

Run `setup.sh` and notice you have one gradle repository, `$KATA_USERNAME-generic-gradle-1`.
The standard layout for such a repository is the following:

```
[orgPath]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]
```

If you look into the repository, you see that you have two artifacts: `duck-1.0.0.jpg` and `fox-1.0.0.jpg`, both in the `acme/<artifact_name>/<artifact_version>/` folder.

## Tasks

You have a team that wants to have all ducks and fox artifacts with the same version in the same folder named after their version so that they look like the following:

```bash
.
└── acme
   └── 1.0.0
       ├── duck-1.0.0.jpg
       └── fox-1.0.0.jpg

```

> **NOTE:** Artifactory does not translate across layouts when copying or moving. Therefore, try to use the same layouts across any given artifacts lifecycle.

### Make the layout and repository

* First we will need to create a layout. In Artifactory, got to [Admin] —> [Repositories] —> [Layouts], then click on "Duplicate" from the layout used in the gradle project.
Jfrog has deprecated 'gradle' layout a while ago and is using 'maven-2-default' layout for gradle repositories
* For Layout Name use `$KATA_USERNAME-layout`, so it's unique.
* In the "Artifact Path Pattern", delete the first `/[module]` that represents a folder structure.
* Test that the layout works as intended. In "Test Artifacts Path Resolution", fill in the following: `acme/1.0.0/fox-1.0.0.jpg`
* Click the `Test` button and check that you get the following resolution:

```
Organization:acme
Module:fox
Base Revision: 1.0.0
Folder Integration Revision:
File Integration Revision:
Classifier:
Extension:jpg
Type:
```

* Save the layout

### Create a new repository using the custom layout

* Now we need to make a repository. Go to [Admin] —> [Repositories] —> [Local], then click "Add repositories" -> choose the Gradle icon.
* As Repository Key use `$KATA_USERNAME-gradlecustom-dev`.
* From the "Repository Layout" dropdown list choose your recently created custom layout.
* Leave the rest of the windows as is, and then hit "Create local repository" button.

### Upload the files

* Go to the repository browser, select the repository you just created and click Deploy.
* Upload the fox and duck images to this repository.
  * Check the "Deploy According To Layout" option. (Only available for single uploads.)

    Fill in the info: `orgPath: acme`, `baseRev: 1.0.0` and `module: fox`
  * Click Deploy.
  * Repeat for duck.jpg
* Check that both uploads have the "Dependency Declaration"
    section in the UI when selecting them.

### Add the dependencies

* Go into your `build.gradle` and change your repository to the URL of the new repository.

    **Info:** When you paste your repository name into `build.gradle`, notice the `ivy` section. This is normally something you would have to write yourself when resolving custom repositories, as Artifactory cannot automatically translate the default maven paths that Gradle automatically uses. This workaround allows Gradle to search the custom layout.

* Execute `./gradlew copyDeps` in your commandline
    > **Gradle Bonus Info**
    > Using `./gradlew` instead of `gradle` means that you're executing the Gradle tasks
    > with the "Gradle Wrapper". The Gradle Wrapper is added to a Gradle project by the
    > creators of the project and holds the version of Gradle that the project was
    > created with. This means that developers at a later date can update their own version
    > of Gradle, but still build the program as it was originally intended, using the wrapper.

* Look into the `build/output` folder to see that the artifacts have been downloaded as they should.

### Working with multiple layouts

Copying an artifact from one layout to another:

* Select the `duck-1.0.0.jpg` artifact from the
    `$KATA_USERNAME-generic-gradle-1` repository.
* Right click, choose "Copy" and choose your `$KATA_USERNAME-gradlecustom-dev`
    as the Target Repository and click "Copy". Don't select "Copy to a Custom Path".
* Locate the artifact in your `$KATA_USERNAME-gradlecustom-dev` repository,
    ~~notice how there's no "Dependency Declaration".
    > We reused the original path of the artifact in our new repository,
    > but Artifactory doesn't know how to
    > parse this into `groupId`, `artifactId` or `version`.~~ 

Now, let's try changing the path when we copy the artifact:

* Select the `duck-1.0.0.jpg` artifact again from the
    `$KATA_USERNAME-generic-gradle-1` repository.
* Copy it to your `$KATA_USERNAME-gradlecustom-dev`, but select the
    "Copy to a Custom Path", and change
    `acme/duck/1.0.0/duck-1.0.0.jpg` to `acme/1.0.0/duck-1.0.0.jpg`.
* Locate the artifact in your `$KATA_USERNAME-gradlecustom-dev` repository,
    notice how it has a "Dependency Declaration" specified.

    > You can imagine migrating artifacts to a different layout requires some work,
    > we have to specify the "correct" new path each time.

Now, let's try changing the layout of our `$KATA_USERNAME-gradlecustom-dev`!

* Go to [Admin] —> [Repositories] —> [Local] and click on your
    `$KATA_USERNAME-gradlecustom-dev` repository.
* In the Repository Layout dropdown, choose the `gradle-default` layout
    and click "Save & Finish".
* Go into the repository and notice how none of the artifacts with the old layout,
    have a "Dependency Decalaration", but the `acme/duck/1.0.0/duck-1.0.0.jpg`
    artifact now has one.

When we're using the default layout, we don't need the custom `ivy` layout pattern!

* Go into the `build.gradle` again and remove the lines,

    ```groovy
    layout 'pattern' , {
        artifact '...' // This is ...
        ivy '[module]/[revision]/ivy.xml'
    }
    ```

* Run the `./gradlew copyDeps` task again, what happens?
  * Why can/can't it locate the `duck-1.0.0.jpg` artifact?
  * Why can/can't it locate the `fox-1.0.0.jpg` artifact?
