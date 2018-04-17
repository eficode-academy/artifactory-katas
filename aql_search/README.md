# AQL searches

Keeping track on a tens of thousands of artifacts is not easy, and even if you got some different search functionalities in the UI, you will need to search programmatically as well.

For that, JFrog provides their Artifactory Query Language, AQL. It gives you a way of searching for artifacts based upon meta-data as well as the directory structure.

> Hint: In order to use these exercises, you either need the JFrog CLI, or use the REST API. All examples here utilizes the REST API. It can be downloaded [here](https://jfrog.com/getcli/)

If you are not an expert in AQL yet, then have JFrogs own AQL documentation open while doing the exercises. The documentation can be found [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-Usage).

## Domain model

The AQL domain model is comprised of several entry entities in green, and their corresponding relational entities.

![Aql domain model](./AQLDomains.png)

Entry entities are the ones you can base your AQL upon.

So e.g. if you want to query a specific property of an item, you have to go through `item` and then `property` (the `@` notation) to find it.

example:

```json
items.find(
    {
    "type":"file",
    "@os":"windows"
    }
)
```

> **Note:** Users without admin privileges can only issue searches through **item** and must have the following fields included in the search: `name`,`repo`, and `path`.

When using AQL from curl, the query itself is best stored in a plaintext document on the side and used like the command below:

```curl -i -X POST -H "$AUTH_HEADER"  -H "Content-Type:text/plain" "$ARTIFACTORY_URL"/api/search/aql -T payload.json```

After executing the setup script, you will see four local repositories, each with different maturity denoted:

* `$KATA_USERNAME`-gradle-sandbox-local
* `$KATA_USERNAME`-gradle-dev-local
* `$KATA_USERNAME`-gradle-v3-local
* `$KATA_USERNAME`-gradle-release-local

In them, we have populated different artifacts with different properties.

## Task

Make queries that does the following:

* Get all artifacts in the Artifactory instance

For the next exercises, we need to limit our searches to your own repositories. You can do that in two ways:

1. By using the `$match` keyword to enable wildcards: 

```Json
"repo":{"$match":"$KATA_USERNAME-*"}
```

1. By listing all the repositories that needs to be searched with the `$or` keyword:

```Json
"$or":[
    {"repo":"$KATA_USERNAME-gradle-sandbox-local"},
    {"repo":"$KATA_USERNAME-gradle-dev-local"}
]
```

### tasks continued

* Get all files in your repositories. The result should be 6 artifacts.
* Get all files that have been downloaded more than 3 times. The result should be 4 artifacts.
* Get all files where the property `os` has the value `linux`. The result should be 2 artifacts.
* Get all files that are over 1 megabyte (in bytes) large. The result should be 2 artifacts.
* Get instances of an artifact that is uploaded later than X days. (this one we have no answer to, because all artifacts have been uploaded within the past minute or two. But have a look at the specification [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-DateandTimeFormat))