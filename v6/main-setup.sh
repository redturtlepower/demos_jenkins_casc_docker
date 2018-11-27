#!/usr/bin/bash

# 1. Check that the folder 'jenkins_home' exists, is empty but the file 'dummy.txt'.
# 2. Run the script 'create-and-deploy-ssh-key-mac.sh'.
#    The mac MUST ALREADY BE CONFIGURED to allow SSH access to the ci-user 'jenkins'.
# 3. Run the script 'run-mac-slave-setup.sh' that installs all dependencies on the build slave (mac) 
#    and also sets up the other build environments on the mac (linux and windows).
# 4. Run the script 'create-and-deploy-ssh-keys-win-lin.sh' that enables ssh access to the just provisiond slaves from step 3
# 5. Run 'docker-compose up' to start the jenkins master which will automatically connect the slaves, as defined in 'src/casc'

# Clear all remote host keys
echo "" > ~/.ssh/known_hosts

bash create-and-deploy-ssh-key-mac.sh
bash run-mac-slave-setup.sh
bash create-and-deploy-ssh-keys-win-lin.sh

rm -df -r ./jenkins_home
mkdir ./jenkins_home
echo -n "Dummy file, needed to keep directory 'jenkins_home' in git repo." > ./jenkins_home/dummy.txt

# Start jenkins master
docker-compose down
docker-compose build --no-cache
docker-compose up
