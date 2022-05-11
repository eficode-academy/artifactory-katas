#!/bin/bash


docker run -d --rm --name gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config:/etc/gitlab-runner \
    gitlab/gitlab-runner:latest

docker exec gitlab-runner gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "https://gitlab.com/" \
  --registration-token "GR13489418qF7Gt-DxxzYkj1FivHf" \

