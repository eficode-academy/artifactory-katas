1. Make your own local Artifactory repository that can resolve to Gradle. Give it the name that was printed in your terminal when you ran `setup.sh`

    **Hint:** You can use the default Gradle-layout for your repository, or you can make your own custom layout. As long as it contains `[org]`, `[module]`, `[baseRev]` and `[ext]`, Artifactory will be able to serve it as a Gradle dependency.


- Create a Gradle repository in the Artifactory UI. The output of `setup.sh` will tell you what to call it.
- Upload `Duck.jpg` through the UI, following the repository layout.
- Modify `build.gradle` so `groupId:artifactId:version` matches your artifact.
  
  **Hint:** If you visit your artifact in the Gradle UI, have a look at the `General` tab, under `Dependency Declaration`. Artifactory has already made the dependency declaration for you, ready to paste into your build script.
- Run `gradle dependencies` and check that your artifact resolves.