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

#Start ubuntu slave, using docker-compose from Docker-for-Mac
cd ubuntu
/usr/local/bin/docker-compose down
/usr/local/bin/docker-compose up -d # detached

cd ..
#Start windows slave (wine):
#cd wine
#docker-compose down
#docker-compose up -d # detached

# Wait for docker to startup:
sleep 10

EOSSH