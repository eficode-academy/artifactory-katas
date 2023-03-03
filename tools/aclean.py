import requests
import json
import click
import os

# do a post request to the artifactory server
# Send the REST API request to the Artifactory server
def send_aql_query(headers, AQL_QUERY):
    # Send the REST API request to the Artifactory server
    response = requests.post(
        ARTIFACTORY_URL + "/api/search/aql",
        headers=headers,
        data=AQL_QUERY,
        auth=(USERNAME, PASSWORD)
    )
    return response

def delete_artifact(repository, path, name):
    # Send the REST API request to delete the artifact
    response = requests.delete(
        ARTIFACTORY_URL + "/" + repository + "/" + path + "/" + name,
        auth=(USERNAME, PASSWORD)
    )
    return response
def loop_artifacts(artifacts, dry_run):
    # Loop through the artifacts and print the details
    for artifact in artifacts:
        # check if the repo, path and name are present in the artifact
        if "repo" not in artifact or "path" not in artifact or "name" not in artifact:
            print("Invalid artifact:", artifact)
            continue

        repository = artifact["repo"]
        path = artifact["path"]
        name = artifact["name"]
            # If --dry-run is specified, just print the file that would be deleted
        if dry_run:
            print("Would delete artifact:", repository, path, name)
            continue
        print("Deleting artifact:", repository, path, name)
        # Send the REST API request to delete the artifact
        response = delete_artifact(repository, path, name)

        # Check if the request was successful
        if response.status_code == 204:
            print("Deleted artifact:", repository, path, name)
        else:
            print("Failed to delete artifact:", repository, path, name)


@click.command()
@click.option('--dryrun', default=True, help='Should the script run in dry-run mode? default is True')
@click.option('--verbose', default=False,help='Verbose mode')
@click.option('--aql', default="aql.aql", help='AQL file, where the response needs to include repo, path and name')
@click.option('--username', default="admin", help='Artifactory username', envvar='ARTIFACTORY_USERNAME')
@click.option('--password', default="password", help='Artifactory password', envvar='ARTIFACTORY_PASSWORD')
@click.option('--url', default="http://localhost:8081/artifactory", help='Artifactory URL', envvar='ARTIFACTORY_URL')
def cleanup(dryrun, verbose,aql, username, password, url):
    """Description goes here"""
    # Define the username and password for the REST API request
    global USERNAME
    global PASSWORD
    global VERBOSE
    global ARTIFACTORY_URL
    ARTIFACTORY_URL = url
    USERNAME = username
    PASSWORD = password
    VERBOSE = verbose
    # Check that the AQL file exists
    if not os.path.exists(aql):
        print("AQL file does not exist. Exiting...")
        exit(1)
    # Read the AQL query from the input file
    with open(aql, "r") as file:
        AQL_QUERY = file.read()

    # Define the headers for the REST API request
    headers = {
        "Content-Type": "text/plain"
    }
    response=send_aql_query(headers, AQL_QUERY)
    # Check if the request was successful
    if response.status_code == 200:
        print(response.text)
        # Get the artifacts from the response
        artifacts = response.json()["results"]
        loop_artifacts(artifacts, dryrun)
        
    else:
        print(f"Failed to retrieve artifacts from Artifactory- status code: {response.status_code} and response: {response.text}")



if __name__ == '__main__':
    cleanup()