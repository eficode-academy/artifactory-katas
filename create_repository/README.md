# Create Artifactory repositories and deploy files

## Prerequisites

In order for you to start working on the katas here, you need to configure the setup.
It happens the first time you try to execure one of the katas. The information you need is the following:

* `ARTIFACTORY_URL` The URL to artifactory. If you are in a course, this will be provided by the trainer
* `ARTIFACTORY_USERNAME` The username to access artifactory, like `admin`. If you are in a course, this will be provided by the trainer
* `ARTIFACTORY_PASSWORD` The password to said user. If you are in a course, this will be provided by the trainer
* `KATA_USERNAME` a unique username to you. All repositories will be prepended that, so make it short and unique.

When you know the four pices of information you can move forward with the exercise.

## Setup

Run `setup.sh` and note the Repository Keys. These are the keys you should use in the exercise.

> :bulb: _Do not_ invent your own Repository Keys. It will make it harder for everyone to identify problems, and our scripts will not be able to clean up the repositories for you.

## Task

### Create repositories through the UI

Open the artificatory url in your favorite browser and login

### Create generic repository

1. Navigate to `Admin`-> "Repositories" -> `local`

    ![Admin button in the Artifactory UI](../.shared/img/1.1.png)
    ![Local repository link](../.shared/img/1.2.png)

2. Make two repositories.

    Use:

    - Package Type: `Generic`
    - Repository Key from the output of running `setup.sh`
    - Repository Layout: `simple-default`

### Deploy some files through the UI

Deploy the `duck-$KATA_USERNAME.jpg` file from the exercise folder to the first repository, and `fox-$KATA_USERNAME.jpg` to the 2nd. Remember to tick the `Deploy According To Layout` box and input the mandatory information for the gradle layout. (EXAMPLE: `org: acme, module:duck, baseRev: 1.0.0, ext: jpg`)

![Deploy button in the Artifactory UI](../.shared/img/1.3.png)
![Deploy button in the deploy dialog](../.shared/img/1.4.png)

### Look at them through the Native browser

> The native browser lets you browse the contents of a repository outside of the Artifactory UI.
It provides a highly responsive, read-only view and is similar to a directory listing provided by HTTP servers.

Locate the first repository in artifactory UI, and right click --> `native browser` to see `duck.jpg` in the path.

![Index of Artifactory Repository](../.shared/img/1.5.png)
