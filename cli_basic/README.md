# Using the JFrog CLI

JFrog maintains a stand-alone CLI tool for interacting with its platform, the JFrog CLI.
In this kata we'll learn how to use the JFrog CLI to interact with Artifactory.

In order to run this exercise, you'll need the JFrog CLI.
The setup script will install it for you, but in case things go wrong you can get it [here](https://jfrog.com/getcli/).

<details>
<summary>:bulb: If you had problems running the setup script</summary>
> Info: If you had problems running the setup script, you'll need to manually configure the JFrog CLI. Run the following command: `./jfrog rt config --url $ARTIFACTORY_URL --user $ARTIFACTORY_USERNAME --password $ARTIFACTORY_PASSWORD --interactive=false`
</details>

For help during the exercise, consult the [JFrog CLI documentation](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory).

## Basic usage

The CLI can interact with all JFrog products, therefore you'll need to specify which you'll interact with.
Take the following command as an example:

`jf rt u <artifact> <path>`

* `rt` stands for _Artifactory_
* `u` stands for _upload_
* `<artifact>` is the local path of the artifact you'd like to upload
* `<path>` is the path on Artifactory to upload the artifact to

e.g.: `jf rt u poem.txt poetry-grade-dev-local/org/acme/poem/1.0.0/poem-1.0.0.txt`.

## Tasks

* Run `./setup.sh`
* Using the JFrog CLI:
    * Upload `moose.jpg` to `${KATA_USERNAME}-grade-dev-local`. Stick to the layout when uploading. Use organisation `acme` and version `1.0.0`.
    * Download the image you just uploaded.

Optional:

* Using the JFrog CLI:
    * Upload `squirrel.jpg` to `${KATA_USERNAME}-grade-dev-local`. Stick to the layout when uploading.
    Use organisation `acme` and version `7.0.0`.
    * Set the property `'animalType':'land_animal'` on the previously uploaded moose artifact.
    * Download the contents of the `${KATA_USERNAME}-grade-dev-local` repo in one command, without its folder structure.
