# Be sure the mac build slave is configured to allow SSH access at this user/IP:
# jenkins@192.168.2.220

# Run remote commands on build slave via SSH:
ssh -T -p22 jenkins@192.168.2.220 << EOSSH

# Mac:
# Check dependencies on mac (Qt, XCode)

# Linux/Windows containers on Mac:
# Download provisioning script from Github:
cd /Users/jenkins
git clone https://github.com/redturtlepower/winlin.git winlin
cd winlin

# tart ubuntu slave
cd ubuntu
bash run-docker.sh

# Go back to winlin dir
cd ..

# Start windows slave (wine):
# cd wine
bash run-docker.sh

# Wait for docker to startup:
sleep 10

EOSSH