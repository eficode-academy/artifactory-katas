# Custom layout

After you have executed the setup script, you have one gradle repository.
The standard layout for such a repository is the following:

```
[org]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]
```

If you look into the repository, you see that you have two artifacts: `duck-1.0.0.jpg` and `fox-1.0.0.jpg`, both in the `acme/<artifact_name>/<artifact_version>/` folder.

You have a team that wants to have all ducks and fox artifacts with the same version in the same folder named after their version so that they look like the following:

```bash
.
└── acme
   └── 1.0.0
       ├── Duck-1.0.0.jpg
       └── Fox-1.0.0.jpg

```

> **NOTE:** Artifactory does not translate across layouts when copying or moving. Therefore, try to use the same layouts across any given artifacts lifecycle.

## High level task

* Make a custom layout that satisfies the requirements of the team. Remember to call the layout by your initials, so you can find it again.
* Make a local gradle repository with the new layout
* Upload through the UI the duck and fox images
* Add the new repository URL for resolving dependencies to your `build.gradle` file.
* Add both images to your gradle dependencies in your `build.gradle`.
* See that they get downloaded with the same dependency declaration no matter what layout artifactory has.

## Detailed task

**Make the layout and repository**

* First we will need to create a layout. In Artifactory, got to [Admin] —> [Repositories] —> [Layout], then click on "Duplicate" from the gradle layout.
* Give a name to "Layout Name", in our case it will be called something with your initials.
* In the "Artifact Path Pattern", delete the first `/[module]` that represents a folder structure.
* Test that the layout works as intended. In "Test Artifacts Path Resolution", fill in the following: `acme/1.0.0/Fox-1.0.0.jpg`
* Click the `Test` button and check that you get the following resolution:

```
Organization:acme
Module:Fox
Base Revision: 1.0.0
Folder Integration Revision:
File Integration Revision:
Classifier:
Extension:jpg
Type:
```

* Save the layout
* Now we need to make a repository. Go to [Admin] —> [Repositories] —> [Local], then click "New" -> choose the Gradle icon.
* Name the repository something starting with your initials.
* From “Repository Layout” dropdown list we will choose our recently created custom layout.
* Leave the rest of the windows as is, and then hit “ Save & Finish” button.

**Upload the files**

* Click on the repository and click deploy
* Upload both duck and fox images with the "deploy according to layout" option.
* Check that they get the `Dependency Declaration` section in the UI when selecting them.

**Add the dependencies**

* Go into your `build.gradle` and change your repository to the URL of the new repository.

```Groovy
apply plugin: "java"
  repositories {
    maven {
        url "your_artifactory_repo_url"
    }
}
  configurations {
    deps
}
  dependencies {
    deps "fox dependency declaration goes here"
    deps "duck dependency declaration goes here"
}
  task copyDeps(type: Copy) {
    from configurations.deps
    into "$buildDir/output"
}

```

* Execute `gradlew copyDeps`
* Look into the `output` folder to see that the artifacts have been downloaded as they should.