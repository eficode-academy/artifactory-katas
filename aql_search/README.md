# AQL searches

> Hint: In order to use these exercises, you either need the jfrog CLI, or use the REST api. All examples here utilizes the CLI. It can be downloaded [here](https://jfrog.com/getcli/)

> Hint: link to JFrogs own AQL documentation can be found [here](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-Usage)

## Domain model

The AQL domain model is comprised of several entry entities in green, and their corresponding relational entities.

![](./AQLDomains.png)

So e.g. if you want to query a specific property of an item, you have to go through `item` and then `property` to find it.

## Using AQL
When using the AQL from the CLI, it needs to be wrapped in a filespec

``` ./jfrog rt s --spec=findallfilesnotdownloaded.json ```

When using AQL from curl, the 

```curl -i -X POST -H "$AUTH_HEADER"  -H "Content-Type:text/plain" "$ARTIFACTORY_URL"/api/search/aql -T payload.json```