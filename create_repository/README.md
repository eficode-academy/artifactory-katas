# Create Artifactory repositories and deploy files

## Prerequisites

In order for you to start working on a kata, you need to run its setup script.
The first time running a setup script will prompt you for the following informtion:

* `ARTIFACTORY_URL` The URL to Artifactory. If you are in a course, this will be provided by the trainer
* `ARTIFACTORY_USERNAME` The username to access artifactory, like `admin`. If you are in a course, this will be provided by the trainer
* `ARTIFACTORY_PASSWORD` The password to said user. If you are in a course, this will be provided by the trainer
* `KATA_USERNAME` a short username unique to you. Created repositories will be prepended with it

## Setup

Run `./setup.sh` and note the repository keys. These are the keys you should use in the exercise.

> ⚠ **Do not** invent your own repository keys, certain kata scripts will not function properly if you do.

## Task

### Create repositories through the UI

Open the Artificatory URL in your favorite browser and log in.

### Create generic repository

1. Navigate: _Admin panel_ ➡ _Repositories_ ➡ _Repositories_ ➡ _local_

    ![Navigating to the Local Repositories panel](../.shared/img/1.1.png)

2. Create two new repositories using the _Add Repositories_ button
    - Repository Type: `Local`
    - Package Type: `Generic`
    - Repository Key: from the output of `setup.sh`
    - Repository Layout: `simple-default`

    ![The Add Repositories button](../.shared/img/1.2.png)

### Deploy some files through the UI

- Navigate: _Application panel_ ➡ _Artifactory_➡ _Artifacts_
- Deploy the `duck-$KATA_USERNAME.jpg` file from the exercise folder
    - Hit the deploy buttin in the Artifactory UI

        ![Deploy button in the Artifactory UI](../.shared/img/1.3.png)
    - Select your first repository as the _Target Repository_
    - Tick the _Deploy According to Layout_ box
    - Input the information for the layout
      e.g.: `org: acme, module:duck, baseRev: 1.0.0, ext: jpg`
- Do the same for the `fox-$KATA_USERNAME.jpg` file, but deploy it to your second repository instead.

![Deploy button in the deploy dialog](../.shared/img/1.4.png)

### Look at them through the Native browser

> The native browser lets you browse the contents of a repository outside of the Artifactory UI.
It provides a highly responsive, read-only view and is similar to a directory listing provided by HTTP servers.

Locate the first repository in Artifactory UI, and right click --> `native browser` to see your duck image in the path.

![Index of Artifactory Repository](../.shared/img/1.5.png)
