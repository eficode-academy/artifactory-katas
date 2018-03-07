# Create Artifactory repositories and upload files
Run `setup.sh` and note the names of the repositories. These are the names you should use in the next step
# **The names of your repositories are given when you run `setup.sh`**. Do not invent your own names.

## Create repositories through the UI

### Generic gradle
1. Make two generic gradle repositories. These should have the Package Type `Gradle` and Repository Layout `gradle-default`.

### Custom layout
1. Make a custom layout.
It can be based on the default gradle layout `[org]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]` with some minor changes, like moving the version number to the end of the filename.
For Folder Integration Revision RegExp, you can use the Maven default of `SNAPSHOT`.
For File Integration Revision RegExp, you can use the Maven default of `SNAPSHOT|(?:(?:[0-9]{8}.[0-9]{6})-(?:[0-9]+))`
1. Make a custom gradle repository using the layout you just created. The Package Type should be `Gradle` and the Repository Layout should be your custom layout

### Virtual repositories
1. Make a virtual repository that covers the 2 generic gradle repositories
1. Make a virtual repository that covers all 3 repositories

## Upload some files through the UI

### Generic gradle
1. Upload `Duck.jpg` to the first repository and `Fox.jpg` to the 2nd. Remember to tick the `Deploy According To Layout` box and input the mandatory information for the gradle layout. (EXAMPLE: `org: volvo, module:Duck, baseRev: 1.0.0, ext: jpg`)
1. Upload `Frog.jpg` to the custom layout repository. Remember to tick the `Deploy According To Layout` box and input the mandatory information you have chosen for your layout.
1. Upload `Moose.jpg` to the 1st virtual repository.
1. Upload `Squirrel.jpg` to the 2nd virtual repository.

## Spot the difference

