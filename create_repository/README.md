# Create Artifactory repositories and upload files
Run `setup.sh` and note the names of the repositories. These are the names you should use in the next step

**The names of your repositories are given when you run `setup.sh`**. _Do not_ invent your own names.

## Create repositories through the UI
* Open the artificatory url in your favorite browser and login

### Create generic repository
1. Navigate to `Admin`-> "Repositories" -> `local`
1. Make two repositories. These should have the Package Type `Generic` and Repository Layout `simple-default`. The names: `$KATA_USERNAME-generic-simple-1` and `$KATA_USERNAME-generic-simple-2`

### Create custom layout and repository based on it
1. Navigate to `Admin`-> "Layouts" -> `local`
1. Make a custom layout with the name `$KATA_USERNAME-layout`.
   1. It must be based on the default gradle layout, but modify to have noticable difference - like swapping `[module]` and `[baserev]` in the filename part (Custom layout: `[org]/[module]/[baseRev](-[folderItegRev])/[baseRev]-[module](-[fileItegRev])(-[classifier]).[ext]`)
   1. For Folder Integration Revision RegExp, you can use the Maven default of `SNAPSHOT`.
   1. For File Integration Revision RegExp, you can use the Maven default of `SNAPSHOT|(?:(?:[0-9]{8}.[0-9]{6})-(?:[0-9]+))`
1. Make a custom gradle repository (name: `$KATA_USERNAME-custom-layout-repo`).<br>
The Package Type should be `Gradle` and the "Repository Layout" should be your custom layout (`$KATA_USERNAME-layout`).

### Create virtual repositories
1. Navigate to `Admin`-> "Repositories" -> `virtual`
1. Make a virtual repository (name: `$KATA_USERNAME-virtual-1`) that covers the 2 generic repositories `$KATA_USERNAME-generic-simple-1`, `$KATA_USERNAME-generic-simple-2`
1. Make a virtual repository (name: `$KATA_USERNAME-virtual-2`) that covers all 3 repositories (`$KATA_USERNAME-virtual-1`, `$KATA_USERNAME-generic-simple-1` and `$KATA_USERNAME-generic-simple-2`

## Upload some files through the UI

1. Upload `Duck.jpg` to the first repository and `Fox.jpg` to the 2nd. Remember to tick the `Deploy According To Layout` box and input the mandatory information for the gradle layout. (EXAMPLE: `org: volvo, module:Duck, baseRev: 1.0.0, ext: jpg`)
1. Upload `Frog.jpg` to the custom layout repository (`$KATA_USERNAME-custom-layout-repo`). Remember to tick the `Deploy According To Layout` box and input the mandatory information you have chosen for your layout.
1. Upload `Moose.jpg` to the 1st virtual repository (`$KATA_USERNAME-virtual-1`).
1. Upload `Squirrel.jpg` to the 2nd virtual repository (`$KATA_USERNAME-virtual-2`).

## Spot the difference
.. between what..?


## Native browser

!!!FILL THIS SECTION OUT!!! this is a good way of accessing artifactory like an old ftp/http site for non-human browsing and consumption. TODO: