# Parameters
REDEPLOY_EXISTING_KEY=false

# Helper variables
KEY_IS_NEW=false

if [ ! -f ~/.ssh/jenkins_slave.pub ]; then
    echo -n "SSH key 'jenkins_slave' has not been found in ~/.ssh/! Creating new key pair and deploying to slaves..."
    ssh-keygen -t rsa -C "jenkins build slave key" -f ~/.ssh/jenkins_slave
    KEY_IS_NEW=true
else
    echo -n "The key 'jenkins_slave' already exists. Do you still want to (re-)deploy it to the hosts? Enter (y) or (n) and press [ENTER]: "
    read -n 2 deploy_decision
    if [ "$deploy_decision" == "y" ]; then
        REDEPLOY_EXISTING_KEY=true
    elif [ "$deploy_decision" == "n" ]; then
        REDEPLOY_EXISTING_KEY=false
    else
        printf "\nWrong input. Aborting...\n"
        exit 1
    fi
fi

echo -n "KEY_IS_NEW:" $KEY_IS_NEW 
printf "\n"
echo -n "REDEPLOY_EXISTING_KEY:" $REDEPLOY_EXISTING_KEY 
printf "\n"

if [ "$KEY_IS_NEW" == true ] || [ "$REDEPLOY_EXISTING_KEY" == true ]; then
    printf "Deploying key to slaves (Ubuntu + Windows + Android)...\n"

    printf "Copy to Ubuntu ----------------------------------------------------------\n"
    # Remove host from known_hosts just in case the key has changed.
    ssh-keygen -f "~/.ssh/known_hosts" -R "[192.168.2.220]:2030"
    # Copy to ubuntu slave - be sure that container 'ubuntu_buildenv' is running on the mac (check with 'docker ps')!
    ssh-copy-id -i ~/.ssh/jenkins_slave.pub -p 2030 jenkins@192.168.2.220

    printf "Copy to Wine ------------------------------------------------------------\n"
    # Remove host from known_hosts just in case the key has changed.
    ssh-keygen -f "~/.ssh/known_hosts" -R "[192.168.2.220]:2040"
    # Copy to wine slave (windows on ubuntu) - be sure that container 'wine_buildenv' is running on the mac (check with 'docker ps')!
    ssh-copy-id -i ~/.ssh/jenkins_slave.pub -p 2040 jenkins@192.168.2.220

    printf "Copy to Android ---------------------------------------------------------\n"
    # Remove host from known_hosts just in case the key has changed.
    ssh-keygen -f "~/.ssh/known_hosts" -R "[192.168.2.220]:2050"
    # Copy to android slave - be sure that container 'android_buildenv' is running on the mac (check with 'docker ps')!
    ssh-copy-id -i ~/.ssh/jenkins_slave.pub -p 2050 jenkins@192.168.2.220
fi
