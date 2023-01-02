# AQL searches

Tracking thousands of artifacts can be a challenge, especially in the UI. To help, JFrog provides the Artifactory Query Language (AQL), giving you a way of searching for artifacts based on meta-data.

In order to run these exercises, you'll need the JFrog CLI or use the REST API.


## Resources

The following will come in handy during the exercises:

- `curl` is available from `bash` and can be used to make calls to the REST API.
- The [Artifactory REST API docs](https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API)
- The [AQL docs](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language)
- The [Filespec reference](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-UsingFileSpecs), when using the JFrog CLI
- The [JFrog CLI docs](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory)

You can use pure AQL when calling the REST API, for example:

```json
items.find(
    {
      "repo": "bobofo-generic-local"
    }
)
```

You can wrap AQL in a Filespec when using the JFrog CLI, for example:

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


## Setup

After executing the setup script, you will see four local repositories, each with different maturity denoted:

* `${KATA_USERNAME}-gradle-sandbox-local`
* `${KATA_USERNAME}-gradle-dev-local`
* `${KATA_USERNAME}-gradle-regtest-local`
* `${KATA_USERNAME}-gradle-release-local`

**NOTE:** The `./setup` script will output two environment variables you should export before starting the exercise, for example:

```
[KATA] Paste this into your terminal for easy access to the variables:
-------------------------------------------------------------------------------
export ARTIFACTORY_URL="http://18.185.125.253/artifactory"
export AUTH_HEADER="Authorization: Basic YWRtaW46cHJhcW1h"
-------------------------------------------------------------------------------
```

When passing AQL to curl, it's easiest to store the query in a separate text document:

```curl -i -X POST -H "$AUTH_HEADER" -H "Content-Type:text/plain" $ARTIFACTORY_URL/api/search/aql -T payload.aql```


## Task

Make queries that do the following:

* Get a list of artifacts in your repositories. The result should be 6 artifacts.
* Get a list of artifacts in your repositories that have been downloaded more than 3 times. The result should be 4 artifacts.
* Get a list of artifacts in your repositories where the property `os` has the value `linux`. The result should be 2 artifacts.
* Get a list of artifacts in your repositories that are over 1MB in size. The result should be 2 artifacts.
* Get a list of artifacts that have been uploaded in the past 24 hours.
