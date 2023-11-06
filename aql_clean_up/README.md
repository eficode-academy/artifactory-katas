# Clean up using AQL

AQL can be used to easily clean up unwanted artifacts, for example, artifacts with a combination of:

* low artifact maturity
* no recent downloads
* older than a certain threshold

Queries matching unwanted artifacts can passed into the JFrog CLI's delete command to easily tidy up.



## Resources

The following will come in handy during the exercises:

- The [AQL docs](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language)
- The [Filespec reference](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-UsingFileSpecs), when using the JFrog CLI
- The [JFrog CLI docs](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory)


You can wrap AQL in a Filespec, for example:

```json

{
  "files": [
    {
      "aql": {
        "items.find": {
          "repo": "fofobo-generic-local"
        }
      }
    }
  ]
}

```

The following is an example of a JFrog CLI call to delete artifacts matching a given Filespec:

``` ./jfrog rt d --spec=filespec.json ```

* `rt` stands for Artifactory
* `d` stand for delete
* `--spec=` defines where the filespec is located


## Setup

* Run the setup script
* Download the JFrog CLI
* Run `jf rt c` to configure jfrog cli with the following information
  * `Artifactory server ID:` `training`
  * `Artifactory URL:` See setup script output
  * `API key:` See your profile in Artifactory


## Tasks

> **Note:** Remember to limit your Filespecs to your repositories only.

* Write a query that finds artifacts:
  * in your `sandbox` or `dev` repository
  * with less than 2 downloads
  * without the `keep` property set to `true`
* Run a search command using your query and verify the found artifacts match expectations
* Then finally, issue a delete command using your query
* Browse Artifactory and confirm the files have been cleaned up


### Extra

We in eficode have created a tool that will help you with the Artifact deletions, based on AQL.
The tools is based in the `tools` [folder]( tools/README.md), where you can find the instructions to use it.

