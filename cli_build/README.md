# Build using JFrog CLI

If your favorite build framework or server does not have a plugin to upload and create builds, then fear not, JFrog have made a stand-alone tool called the JFrog CLI.

In order to use these exercises, you need the jfrog CLI. All examples and exercises here utilizes the CLI.
It will be downloaded using the setup script, but if something goes wrong, it can be downloaded [here](https://jfrog.com/getcli/).

If you at any point need to look at the documentation, then here is the [link](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).

## Using the CLI

The CLI span all JFrogs products, and therefore you need to specify what you are calling and then the method.
Take the following command as an example:

``` ./jfrog rt u <your artifacts> <repo path>```

* `rt` stands for a`rt`ifactory
* `u` stands for `u`pload
* `<your artifacts>` is where on your local machine the artifact
* `<repo path>` is the full path on Artifactory where the artifact needs to be uploaded to, like `${KATA_USERNAME}-gradle-dev-local/acme/fox/4.5.0/fox-4.5.0.jpg`.

## Tasks

* run `setup.sh`
* upload the `moose.jpg` image with version 1.0.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo
* upload the `squirrel.jpg` image with version 1.2.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo

Optional tasks

* download everything from the `${KATA_USERNAME}-gradle-dev-local` repo in one command without the folder structure.
* upload `fox.jpg` with version `7.0.0` and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo with the property `'animalType':'land_animal'` set


## Build through the CLI

The CLI also enables you to make builds entities in Artifactory.

The way to do it is

* Upload files with the `--build-name` and `--build-number` arguments added.
* (optional) upload the environment variables with the `bce` command. `bce` stands for build-collect-env.
* publish the build to Artifactory with the `bp` command

## Task

* Think of a build name and build number to use. It can be something fitting or something funny.
* Upload the `moose.jpg` and `squirrel.jpg` image both with version 2.2.0 and under the `acme` organisation in the `${KATA_USERNAME}-gradle-dev-local` repo. Remember to add the build name and number to the uploads.
* Include environment variables to the build.
* Publish your build through the CLI.
* Promote your build from `${KATA_USERNAME}-gradle-dev-local` to `${KATA_USERNAME}-gradle-release-local`. 
* Go to the Artifactory UI, find `${KATA_USERNAME}-gradle-release-local` and check that the files have been copied over.

You have now added properties, set name/number of your build and succesfully promoted the files to a different maturity level through the CLI.