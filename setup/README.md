Setup:
In order to run all the katas in this repository, you need both Artifactory Pro and Jenkins running.

https://stackoverflow.com/questions/44727535/jenkins-docker-set-admin-password-from-environment-variable

https://github.com/foxylion/docker-jenkins

To get a license, use your email address or create one at:
http://mailnesia.com

https://temp-mail.org/en/


```tfvars
extra_bootstrap_cmds = "sudo -u ubuntu bash -c 'cd /home/ubuntu && git clone https://github.com/eficode-academy/artifactory-katas.git'"

```

And remember to run the `artifactory.sh` script from terraform infrastructure to set up both gradle and java.


When you have started artifactory through the docker-compose file, remember to go into admin interface -> security -> allow anonymous access.