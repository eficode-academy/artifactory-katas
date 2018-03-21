# Promote using cUrl

Even though there is an endpoint to make a build through cUrl, it is only advisable to do a last resort approach.
For more info on what the JSON looks like for such a call, look at the example on [JFrogs webpage](https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API#ArtifactoryRESTAPI-BuildUpload).

In order to make the build itself, either use the jenkins plugin, the gradle plugin, or the [CLI](https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Artifactory#CLIforJFrogArtifactory-BuildIntegration-PublishingaBuild).

## look at the builds

In order to look at the builds, 

```bash
curl -i -X GET "$ARTIFACTORY_URL"/api/build/
```
curl -i -X GET -H "$AUTH_HEADER" "$ARTIFACTORY_URL"/api/build/jenkins-artifactory-plugin/22


```JSON
{
 "status": "staged",                            // new build status (any string)
 "comment" : "Tested on all target platforms.", // An optional comment describing the reason for promotion. Default: ""
 "ciUser": "builder",                           // The user that invoked promotion from the CI server
 "timestamp" : ISO8601,                 // the time the promotion command was received by Artifactory (It needs to be unique), 
                                                // the format is: 'yyyy-MM-dd'T'HH:mm:ss.SSSZ'. Example: '2016-02-11T18:30:24.825+0200'.
 "dryRun" : false,                              // run without executing any operation in Artifactory, but get the results to check if the operation can succeed. Default: false
 "sourceRepo" : "libs-snapshot-local",          // optional repository from which the build's artifacts will be copied/moved
 "targetRepo" : "libs-release-local",           // optional repository to move or copy the build's artifacts and/or dependencies
 "copy": false,                                 // whether to copy instead of move, when a target repository is specified. Default: false
 "artifacts" : true,                            // whether to move/copy the build's artifacts. Default: true
 "dependencies" : false,                            // whether to move/copy the build's dependencies. Default: false.
 "scopes" : [ "compile", "runtime" ],           // an array of dependency scopes to include when "dependencies" is true
 "properties": {                                // a list of properties to attach to the build's artifacts (regardless if "targetRepo" is used).
     "components": ["c1","c3","c14"],
     "release-name": ["fb3-ga"]
 },
 "failFast": true                               // fail and abort the operation upon receiving an error. Default: true
}
```


## Set properties on the artifacts of a build
`curl -i -X POST -H "$AUTH_HEADER"  -H "Content-Type:application/json" -T promote.json "$ARTIFACTORY_URL"/api/build/promotejenkins-artifactory-plugin/29`

> Hint: If you do not want to promote your build, but want to add properties to all the artifacts then replace the `targetRepo` with `sourceRepo`
```JSON
{
    "status": "L3",
    "sourceRepo": "sal-generic-gradle-3",
    "copy": true,
    "artifacts": true,
    "properties": {
        "components": [
            "c1",
            "c3",
            "c14",
            "hej igen"
        ],
        "release-name": [
            "fb3-ga"
        ]
    }
}
```