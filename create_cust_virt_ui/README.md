### Create custom layout and repository based on it
1. Navigate to `Admin`-> "Layouts" -> `local`
1. Make a custom layout with the name `$KATA_USERNAME-layout`.
   1. It must be based on the default gradle layout, but modify to have noticable difference - like swapping `[module]` and `[baserev]` in the filename part (Custom layout: `[org]/[module]/[baseRev](-[folderItegRev])/[baseRev]-[module](-[fileItegRev])(-[classifier]).[ext]`)
   1. For Folder Integration Revision RegExp, you can use the Maven default of `SNAPSHOT`.
   1. For File Integration Revision RegExp, you can use the Maven default of `SNAPSHOT|(?:(?:[0-9]{8}.[0-9]{6})-(?:[0-9]+))`
1. Make a custom gradle repository (name: `$KATA_USERNAME-custom-layout-repo`).<br>
The Package Type should be `Gradle` and the "Repository Layout" should be your custom layout (`$KATA_USERNAME-layout`).

### Create virtual repositories
1. Navigate to `Admin`-> "Repositories" -> `virtual`
1. Make a virtual repository (name: `$KATA_USERNAME-virtual-1`) that covers the 2 generic repositories `$KATA_USERNAME-generic-simple-1`, `$KATA_USERNAME-generic-simple-2`
1. Make a virtual repository (name: `$KATA_USERNAME-virtual-2`) that covers all 3 repositories (`$KATA_USERNAME-virtual-1`, `$KATA_USERNAME-generic-simple-1` and `$KATA_USERNAME-generic-simple-2`
