# Clean up using AQL

As a centralized artifact storage medium, Artifactory storage requirements can easily run out of control.
How can we store every build we make inside Artifactory, while still cleaning up unused or unwanted artifacts?

What qualifies as an erasable artifact is dependent on company policy and external regulations, but often follows these characteristics:

* Is not promoted to a certain maturity
* Has 0 or very few downloads
* Has been in a repository for a certain amount of time

These requirements can also vary from team to team, so it's good to smaller scripts that takes care of certain repositories.

AQL is a good starting point in identifying these erasable artifacts.

Querying Artifactory and making the REST calls to delete the artifacts could be made into a small custom tailored bash script. Fortunately JFrog has made a command line interface to do that, and other things. 

In order to use these exercises, you need the jfrog CLI. All examples and exercises here utilizes the CLI. It can be downloaded [here](https://jfrog.com/getcli/)

Link to JFrogs own AQL documentation can be found [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-Usage)

## Using the CLI

When using the AQL from the CLI, it needs to be wrapped in a filespec

The CLI span all JFrogs products, and therefore you need to specify what you are calling and then the method.
Take the following command as an example:

``` ./jfrog rt s --spec=filespec.json ```

* `rt` stands for a`rt`ifactory
* `s` stand for search
* `--spec=` defines where the filespec is located.

### File Spec reference
https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-UsingFileSpecs

These are the two models that can be used:<br>
1. Full JSON (both `REST API(curl)` and `jfrog.exe`):

```json

{
  "files": [
    {
      "aql": {
        "items.find": {
                "repo": "<my_repo>"
        }
      }
    }
  ]
}

```

## Tasks

> **Note:** Remember to limit your AQL's to your repositories only. Refer back to [aql_search](../aql_search/README.md) for info on how to do that.

* Download the jfrog cli as stated by the setup script
* Run `./jfrog rt c` to configure jfrog cli with the following information
  * `Artifactory server ID:` training
  * `Artifactory URL:` the setup script will give you that
  * `API key:` You can see this under the `/profile` url in artifactory

Now you are ready to get to work with the CLI:

* Write an AQL query that finds all artifacts that
  * Is in the `sandbox` or `dev` repository
  * Has less than 2 downloads
  * Does not have the `keep` property set to `true`
* Execute with with a normal curl REST call, and examine how many artifacts you get back.
* Convert it to a `filespec` file
* Run `./jfrog rt s --spec=filespec.json`
* Look at the result and compare the number to your original search
* Then finally, issue a delete command `./jfrog rt del --spec=filespec.json` to delete the files
* Look into artifactory to make sure they are downloaded.
