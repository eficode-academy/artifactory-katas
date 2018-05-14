# Build using JFrog CLI

If your favorite build framework or server does not have a plugin to upload and create builds, then fear not, JFrog have made a stand-alone tool called the JFrog CLI.

In order to use these exercises, you need the jfrog CLI. All examples and exercises here utilizes the CLI.
It will be downloaded using the setup script, but if something goes wrong, it can be downloaded [here](https://jfrog.com/getcli/).

## Using the CLI

When using the CLI

The CLI span all JFrogs products, and therefore you need to specify what you are calling and then the method.
Take the following command as an example:

``` ./jfrog rt u <your artifacts> <repo path>```

* `rt` stands for a`rt`ifactory
* `u` stands for `u`pload



## Tasks

* run `setup.sh`
* upload the `moose.jpg` image with version 1.0.0
* upload the `squirrel.jpg` image with version 1.2.0
* 

```
 ./jfrog rt u moose.jpg sal-gradle-dev-local/acme/moose/1.0.0/moose-1.0.0.jpg --build-name=sal-build --build-number=1
 ./jfrog rt u squirrel.jpg sal-gradle-dev-local/acme/squirrel/1.0.0/squirrel-1.0.0.jpg --build-name=sal-build --build-number=1
 ./jfrog rt bce sal-build 1
 ./jfrog rt bp sal-build 1
 ```