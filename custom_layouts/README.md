# Custom layout

After you have executed the setup script, you have one gradle repository.
The standard layout for such a repository is the following:

```
[org]/[module]/[baseRev](-[folderItegRev])/[module]-[baseRev](-[fileItegRev])(-[classifier]).[ext]
```

If you look into the repository, you see that you have two artifacts: `duck-1.0.0.jpg` and `fox-1.0.0.jpg`, both in the `acme/<artifact_name>/<artifact_version>` folder.

You have a team that wants to have all ducks and fox artifacts with the same version in the same folder named after their version so that

```bash
.
└── acme
   └── 1.0.0
       ├── Duck.jpg
       └── Fox.jpg

```

## High level task

* Make a custom layout that satisfies the requirements of the team. Remember to call the layout by your initials, so you can find it again.
* Make a virtual repository with the new layout.
* Check that the new

> Hint: In order for
