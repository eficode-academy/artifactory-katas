#!/bin/bash
GITLAB_TOKENS=("GR1348941YxyYzKzr5oK_zc_6KpHX" "GR1348941qXji2Hm5d6CtFxVoBtmk" "GR1348941jCrzkdvZssFn42pRJ7MY" "GR1348941BD329xAFWjKtBjPgT5sy")
RUNNER_NAME=gitlab-runner
COUNT=1
for t in ${GITLAB_TOKENS[@]}; do
  echo $t
  echo $COUNT

docker run -d --rm --name $RUNNER_NAME$t \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v gitlab-runner-config$COUNT:/etc/gitlab-runner \
    gitlab/gitlab-runner:ubuntu

docker exec $RUNNER_NAME$t gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image ubuntu:latest \
  --url "https://gitlab.com/" \
  --registration-token $t \

((COUNT++))
done

