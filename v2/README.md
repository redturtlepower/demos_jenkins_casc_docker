About v3

Installs following plugins:
- workflow-aggregator
  # Jenkins pipeline
- blueocean
  # nice UI for pipeline
- bitbucket
  # build our projects triggered by commits on private git repos on bitbucket


1 Requirements
==============
- docker
- docker-compose

`sudo apt-get install docker.io -y && sudo apt-get install docker-compose -y`

2 Avoid typing sudo
==============
`sudo groupadd docker`
`sudo usermod -aG docker $USER`

Then restart your computer.

3 Run
==============
# Update: Folloing 2 lines no longer apply! The mentioned script is already included in docker base image. No actions required.
# The script has to be made executable on the host, not on the Dockerfile!
# `sudo chmod +x ./src/install-plugins.sh`

# Set permissions on mounted home directory (see docker-compose.yaml file)
# https://github.com/jenkinsci/docker/issues/177
`sudo chown 1000 jenkins_home` 

`docker-compose up`

4 Control
==============
Open a browser and navigate to `127.0.0.1/jenkins`

5 Stop
==============
Type CTRL+C in the terminal or 
`docker-compose down`
