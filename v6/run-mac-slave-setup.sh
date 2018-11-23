# Be sure the mac build slave is configured to allow SSH access at this user/IP:
# jenkins@192.168.2.220

# SSH into mac build slave:
ssh -p22 jenkins@192.168.2.220
echo "Hello from Mac Mini!"

# Mac:
# Check dependencies on mac (Qt, XCode)

# Linux/Windows containers on Mac:
# Download provisioning script from Github:
cd /Users/jenkins
git clone https://github.com/redturtlepower/winlin.git winlin

#Start ubuntu slave:
cd /Users/jenkins/winlin/ubuntu
docker-compose down
docker-compose up -d # detached

#Start windows slave (wine):
#cd /Users/jenkins/winlin/wine
#docker-compose down
#docker-compose up -d # detached

# Wait for docker to startup:
sleep 10

# End ssh session:
exit