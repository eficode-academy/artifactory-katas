# Artifactory Cleanup Tool

This script helps to clean up Artifactory repositories by deleting unwanted artifacts. 
It uses the Artifactory REST API and AQL to query and delete artifacts.

## Installation

### Bare installation

To use this tool, you need Python 3 installed on your machine.

To install the required libraries, run the following command:

```Bash
pip install requests click
```

Usage

To run the cleanup tool, use the following command:

```bash

python aclean.py --aql aql.aql --username admin --password password --url http://localhost:8081/artifactory
```

### Docker

The tool can also be run as a Docker container.
Right now, no official Docker image is available, so you need to build it yourself.

To build the Docker image, run the following command:

```bash
docker build -t artifactory-cleanup -f dist/Dockerfile .
```

To run the Docker image, use the following command:

```bash 
docker run -it --rm -v $(pwd)/aql.aql:/aql.aql artifactory-cleanup --aql /aql.aql --username admin --password password --url http://localhost:8081/artifactory
```

## Usage

You can specify the following options:

    --dryrun: If set to True, the script will only print the artifacts that would be deleted without actually deleting them. The default value is True.
    --verbose: If set to True, the script will print more detailed information during the cleanup process. The default value is False.
    --aql: The path to the AQL file that defines the artifacts to be deleted. The file should contain a valid AQL query with the fields repo, path, and name. The default value is aql.aql.
    --username: The username to use to authenticate with Artifactory. The default value is admin.
    --password: The password to use to authenticate with Artifactory. The default value is password.
    --url: The URL of the Artifactory instance to connect to. The default value is http://localhost:8081/artifactory.


The cleanup function accepts several options, which can also be set as environment variables. Here are the environment variables that can be used:

    ARTIFACTORY_USERNAME: The Artifactory username to use for the REST API requests. 
    ARTIFACTORY_PASSWORD: The Artifactory password to use for the REST API requests.
    ARTIFACTORY_URL: The URL of the Artifactory server.


The options are evaluated in the following order:
    Retrieve the value from the CLI
    Retrieve the value from the environment
    Retrieve the default value

### Examples
Displaying what artifacts that should be deleted in dry-run mode

To see which artifacts would be deleted without actually deleting them, simply run the script (the --dryrun option is set to True by default):

```bash
python cleanup.py
```

Deleting artifacts

To actually delete the artifacts, run the script with the --dryrun option set to False:

```bash

python cleanup.py --dryrun False
```

## AQL

The AQL file defines the artifacts to be deleted. It should contain a valid AQL query with the fields repo, path, and name.
There are many examples of AQL queries in the [search-aql](search-aql) folder.

More info: https://www.eficode.com/blog/4-practical-tips-to-keep-your-artifactory-clean-and-lean 
And: https://jfrog.com/help/r/artifactory-how-to-start-using-aql