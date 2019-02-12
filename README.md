# Artifactory kata

Exercises made for Praqma's one day [introduction to Artifactory](https://www.praqma.com/training/artifactory-intro/)

## Katas

- [create_repository](./create_repository/README.md)
- [gradle_intro](./gradle_intro/README.md)
- [custom_layouts](./custom_layouts/README.md)
- [virtual_repositories](./virtual_repositories/README.md)
- [gradle_build](./gradle_build/README.md)
- [jenkins_build](./jenkins_build/README.md)
- [aql_search](./aql_search/README.md)
- [aql_cleanup](./aql_clean_up/README.md)

## Setup requirements

If you want to be able to run every exercise in this repository you need:

- An Artifactory Pro or Enterprise server
- A Jenkins server
- Gradle and JDK installed
- Git bash
- JFrog CLI

## Authenticating towards Artifactory

You will need to authenticate to Artifactory either by a username/password
 combination or an API Key. If you use a username/password combination, please
 don't use your "plain password" but instead use the "Encrypted Password" for
 your Artifactory user.

You will find both the `API Key` and your `Encrypted Password` Under
 "Welcome, \<user\>" and "Edit Profile" in the Artifactory UI.
 Unlock with your password and look under "Authentication Settings".
 Read more: [Using Your Secure Password](https://www.jfrog.com/confluence/display/RTF/Centrally+Secure+Passwords).

NB: It's not currently possible to do the Gradle exercises using an `API Key`.

## Links

- [General Artifactory documentation](https://www.jfrog.com/confluence/pages/viewpage.action?pageId=46107472)
- [REST API](https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API)
- [JFrog CLI](https://www.jfrog.com/confluence/display/CLI/JFrog+CLI)
- [File specs](https://www.jfrog.com/confluence/display/RTF/Using+File+Specs#UsingFileSpecs-Overview)
- [Pipeline DSL](https://www.jfrog.com/confluence/display/RTF/Working+With+Pipeline+Jobs+in+Jenkins)
