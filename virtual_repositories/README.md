# Virtual repositories

You want to have one endpoint for all developers to get their artifacts regardless of maturity or if they are internal or external.
At the same time, you also want all published artifacts to go into the repository with lowest maturity.

After executing the setup script, you will see four local repositories, each with different maturity denoted:

* USERNAME-gradle-sandbox-local
* USERNAME-gradle-dev-local
* USERNAME-gradle-regtest-local
* USERNAME-gradle-release-local

What we need now is a virtual repository spanning them all, making sure that all artifacts published to the virtual goes in the sandbox repository.

## Tasks

* Run `gradle dependencies --refresh-dependencies` and see that the dependencies resolve from the
    USERNAME-gradle-sandbox-local repository.
* Add the `fox-1.5.3.jpg` artifact from the USERNAME-gradle-release-local as a dependency as well.
    > **Hint:** If you visit your artifact in the Gradle UI,
    > have a look at the `General` tab, under `Dependency Declaration`.
    > Artifactory has already made the dependency declaration for you,
    > ready to paste into your build script.
* Run `gradle dependencies --refresh-dependencies` and see what happens.

> We can either add repositories one by one in the `build.gradle` or
> create a virtual repository in Artifactory that spans the ones we need need.

### Creating a Virtual Repository

* Go to [Admin]-->[Repositories]-->[Virtual] and create a new `Gradle` typed Virtual Repository.
    The repository should span all four local repositories. Call it `USERNAME-gradle-all-virtual`.
* Set Default Deployment Repository to your sandbox repository to make you able to upload artifacts to the repository.
* Upload `fox-USERNAME.jpg` through the UI to the virtual repository you just created, following the repository layout. (Toggle the "Deploy According To Layout" and set the `orgPath`, `module` and `baseRev` to `acme`, `fox` and `1.0.0`.)
* Locate the uploaded artifact in the repository browser.
    > Notice it will be available in "two" repositories, find both!
* Add the fox image as well to your gradle dependencies in your `build.gradle`.

### Resolving from a Virtual Repository

* In the `build.gradle` replace the USERNAME-gradle-sandbox-local with your
    new (virtual) repository URL.
* Run `gradle dependencies --refresh-dependencies` and check that all artifacts resolve.

Great! Now you can resolve artifacts from any of the `sandbox`, `dev`, `regtest` and `release` repositories.

### Resolving from a Remote Repository

Being able to resolve from all of our internal repositories is awesome,
    but at some point we might need a library that someone else's made.

If we're making a Java application, we will want to test it.
    The JUnit framework is a great help for this, so let's add it as a dependency!

* Add the following to your `build.gradle`, under dependencies:

    ```groovy
    // https://mvnrepository.com/artifact/junit/junit
    compile(group: 'junit', name: 'junit', version: '4.12')
    ```

* For sanity, run `gradle dependencies --refresh-dependencies` and see it fail.
    We haven't added "JCenter" which we'd like to resolve it from, as one of our repositories.

### Creating a Remote Repository

* Create a `Remote` Repository with the Artifactory UI. Name it `$USERNAME-jcenter-remote` so it's unique to you. It should be of package type `Gradle` and should proxy `https://jcenter.bintray.com`
* Edit your virtual repository so it also includes the remote one.
* Run `gradle dependencies --refresh-dependencies` and verify that all artifacts resolve.

## More on Virtual Repositories

In most organzations it will make sense to have multiple virtual repositories that span
    different combinations of repositories depending on the needs of your application.
    The ones below are just provided as examples.

* A "sandbox, development and JCenter-remote" repository, for sandbox testing your application.
* A "Quality Assurance and Release" repostory, for doing a functional test,
    specifying dependency to an explicit artifact in the QA-repository and using the rest from
    the release repository.
  * Note that this combination has no remote repository.
* Maybe an "all internal repositories" repository, for verifying that all dependencies are available
    from within the organizaion, if this is something you require.

A virtual repository can even span other virtual repositories.
    Don't create unnecessarily complex repository structures with this feature.
