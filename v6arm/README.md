About v6arm

This creates a jenkins master on a Raspberry 3 b with raspbian 9 (stretch).



Installs following plugins:
- configuration-as-code
  
  Why not using init.groovy.d init scripts?
  
  Because DSL seems easier to maintain.
  
  However this plugin is not used to install other plugins, because this would happen at runtime.
  
- workflow-aggregator
  
- Jenkins pipeline

This example also demonstrates how to connect to a build slave (agent) with ssh public/private key pair.

1 Requirements
==============
- docker
- docker-compose

## Install docker

`sudo apt-get install docker.io -y`

## Install docker-compose

`curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && sudo python3 get-pip.py`
`sudo pip3 install docker-compose`

docker-compose has been installed to `/usr/local/bin`. Add `/usr/local/bin` to PATH

`sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`

Check installation
`docker-compose --version`
`docker-compose version 1.25.5, build unknown`
`docker -v`
`docker version 19.03.8, build afacb8b`

-- Agent setup --
You have to do a MANUAL setup of that agent; this is not done by this example.
Precisely, there is a Mac Mini in the local network at IP 192.168.2.220 that has a public ssh key in authorized_keys.
This has been done by first generating a key on the jenkins master machine via
`ssh-keygen -t rsa -C "my-email@gmail.com" -f .ssh/jenkins_slave`
and then pushing the public key to the slave via
`ssh-copy-id -i jenkins_slave.pub jenkins@192.168.2.220` 
The Mac must be configured to allow SSH access to the Jenkins build agent user. There are two steps required:

- Create a guest user named "jenkins".
- Allow SSH access: To do this, in the settings set the checkbox at "remote login".
You might need to install openssh server via
`sudo apt-get install openssh-server`
which I at least had to do to make my Ubuntu master (tested in Virtual Box on Windows) could use ssh.
Moreover, the jenkins agent needs an installed JAVA JDK (JRE is not enough, at least for me the Mac could not figure out the JAVA path. `which java` worked, but version info `java -v` did not due to "path not found", unless I installed the JDK).



Avoid typing sudo
--------------
`sudo groupadd docker`
`sudo usermod -aG docker $USER`

Then restart your computer.

2 Run
==============
Update: Following 2 lines no longer apply! The mentioned script is already included in docker base image. No actions required.

The script has to be made executable on the host, not on the Dockerfile!

`sudo chmod +x ./src/install-plugins.sh`

Set permissions on mounted home directory (see docker-compose.yaml file)

https://github.com/jenkinsci/docker/issues/177

`sudo chown 1000 jenkins_home` 

`docker-compose up`

If this gives an error, try `docker-compose down`.
To see if there already is a container running, type `docker container ls`.
If yes, you'll see a name in the printed row.
Now you can stop that container with `docker container stop v1_master_1`, where v1_master_1 is the name of the running container.
Now you can start again via `docker-compose up`.

To force rebuild, clean the jenkins_home directory (but keep the file 'dummy' to keep the folder in git, because empty folders get deleted).
Then call `docker-compose build --no-cache && docker-compose up`

-- 
Alternative to start docker compose and ensure the jenkins_home folder is correct:
Run in a terminal: `bash main-setup.sh`

3 Control
==============
On localhost, open a browser and navigate to `127.0.0.1/jenkins`

If ran on a raspberry in the network, open **192.168.2.110:8080/jenkins**

4 Stop
==============
Type CTRL+C in the terminal or 
`docker-compose down`