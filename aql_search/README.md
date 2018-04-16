# AQL searches

Keeping track on a tens of thousands of artifacts is not easy, and even if you got some different search functionalities in the UI, you will need to search programmatically as well.

For that, JFrog provides their Artifactory Query Language, AQL.

> Hint: In order to use these exercises, you either need the jfrog CLI, or use the REST API. All examples here utilizes the REST API. It can be downloaded [here](https://jfrog.com/getcli/)

> Hint: link to JFrogs own AQL documentation can be found [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-Usage)

## Domain model

The AQL domain model is comprised of several entry entities in green, and their corresponding relational entities.

![Aql domain model](./AQLDomains.png)

So e.g. if you want to query a specific property of an item, you have to go through `item` and then `property` to find it.

> **Note:** Users without admin privileges can only issue searches through **item** and must have the following fields included in the search: `name`,`repo`, and `path`.

When using AQL from curl, the query itself is best stored in a plaintext document on the side and used like the command below:

```curl -i -X POST -H "$AUTH_HEADER"  -H "Content-Type:text/plain" "$ARTIFACTORY_URL"/api/search/aql -T payload.json```

After executing the setup script, you will see four local repositories, each with different maturity denoted:

* USERNAME-gradle-sandbox-local
* USERNAME-gradle-dev-local
* USERNAME-gradle-v3-local
* USERNAME-gradle-release-local

## Task

Make queries that does the following:

* Get all artifacts in the Artifactory instance

For the next exercises, we need to limit our searches to your own repositories. You can do that in two ways:

1. By using the `$match` keyword to enable wildcards: `"repo":{"$match":"$KATA_USERNAME-*"}`
1. By listing all the repositories that needs to be searched with the `$or` keyword:

```Json
"$or":[
    {"repo":"$KATA_USERNAME-gradle-sandbox-local"},
    {"repo":"$KATA_USERNAME-gradle-dev-local"}
]
```

### tasks continued

* Get all files in your repositories
* Get all files that have been downloaded more than 3 times
* Get all files where the property `os` has the value `linux`
* Get all files that are over 1 megabyte large.
* Get instances of an artifact that is uploaded later than X days.