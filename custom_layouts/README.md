# Custom layout

After you have executed the setup script, you have one gradle repository.
The standard layout for such a repository is the following:

```
[org]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]
```

If you look into the repository, you see that you have two artifacts: `duck-1.0.0.jpg` and `fox-1.0.0.jpg`, both in the `acme/<artifact_name>/<artifact_version>` folder.

You have a team that wants to have all ducks and fox artifacts with the same version in the same folder named after their version so that

```bash
.
└── acme
   └── 1.0.0
       ├── Duck-1.0.0.jpg
       └── Fox-1.0.0.jpg

```

## High level task

* Make a custom layout that satisfies the requirements of the team. Remember to call the layout by your initials, so you can find it again.
* Make a virtual repository with the new layout.
* Check that the new

> Hint: In order for


## Detailed task

* First we will need to create a layout. In Artifactory, got to [Admin] —> [Repositories] —> [Layout], then click on "Duplicate" from the gradle layout.
* Give a name to "Layout Name", in our case it will be called something with your initials.
* In the "Artifact Path Pattern", delete the first `/[module]` that represents a folder structure.
* Test that the layout works as intended. In "Test Artifacts Path Resolution", fill in the following: `acme/1.0.0/Fox-1.0.0.jpg`
* Save the layout
* Now we need to make a repository. Go to [Admin] —> [Repositories] —> [Virtual], then click "New" -> choose the Gradle icon.
* Name the repository something starting with your initials.
* From “Repository Layout” dropdown list we will choose our recently created custom layout.
* Leave the rest of the windows as is, and then hit “ Save & Finish” button.
