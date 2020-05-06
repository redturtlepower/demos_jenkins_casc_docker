# Parameters
REDEPLOY_EXISTING_KEY=false

# Helper variables
KEY_IS_NEW=false

if [ ! -f ~/.ssh/jenkins_slave.pub ]; then
    echo -n "SSH key 'jenkins_slave' has not been found in ~/.ssh/! Creating new key pair and deploying to slaves..."
    ssh-keygen -t rsa -C "jenkins build slave key" -f ~/.ssh/jenkins_slave
    KEY_IS_NEW=true
else
    echo -n "The key 'jenkins_slave' already exists. Do you want to re-create it? Enter (y) or (n) and press [ENTER]: "
    read -n 2 recreate_decision
    if [ "$recreate_decision" == "y" ]; then
        echo "" > ~/.ssh/known_hosts # Remove all keys from all known hosts
        ssh-keygen -t rsa -f ~/.ssh/jenkins_slave # Generate a new ssh key pair
        # Create identity due to non-standard name
        ssh-agent bash
        ssh-add ~/.ssh/jenkins_slave
        KEY_IS_NEW=true
    elif [ "$recreate_decision" == "n" ]; then
        printf "The existing key has not been touched.\n"
        echo -n "Do you want to (re-)deploy the key to the hosts? Enter (y) or (n) and press [ENTER]: "
        read -n 2 deploy_decision
        if [ "$deploy_decision" == "y" ]; then
            REDEPLOY_EXISTING_KEY=true
        elif [ "$deploy_decision" == "n" ]; then
            REDEPLOY_EXISTING_KEY=false
        else
            printf "Wrong input. Aborting...\n"
            exit 1
        fi
    else
        printf "Wrong input. Aborting...\n"
        exit 1
    fi
fi

echo -n "KEY_IS_NEW:" $KEY_IS_NEW 
printf "\n"
echo -n "REDEPLOY_EXISTING_KEY:" $REDEPLOY_EXISTING_KEY 
printf "\n"

if [ "$KEY_IS_NEW" == true ] || [ "$REDEPLOY_EXISTING_KEY" == true ]; then
    printf "Deploying key to slaves...\n"
    printf "Copy to Mac ----------------------------------------------------------\n"
    # Remove host from known_hosts just in case the key has changed.
    ssh-keygen -f "~/.ssh/known_hosts" -R "[192.168.2.220]:22"
    # Copy to mac slave
    ssh-copy-id -i ~/.ssh/jenkins_slave.pub jenkins@192.168.2.220
fi
