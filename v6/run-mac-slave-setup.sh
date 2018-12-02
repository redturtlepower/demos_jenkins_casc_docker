# Be sure the mac build slave is configured to allow SSH access at this user/IP:
# jenkins@192.168.2.220

# Run remote commands on build slave via SSH:
ssh -p22 jenkins@192.168.2.220 '/bin/bash -s' << 'EOF'

echo 'This should run on mac. Test the user: user = ' $USER
echo 'Docker is likely installed on /usr/local/bin on the Mac. That path isnt on the PATH, is it?'
echo 'Mac PATH: ' $PATH

# -------------------------------------------------------------------
# Mac:
# Check dependencies on mac (Qt, XCode) => TODO

# -------------------------------------------------------------------
# Linux/Windows containers on Mac:
# Download provisioning script from Github:
cd /Users/jenkins
git clone https://github.com/redturtlepower/winlin.git winlin
cd winlin

	# ---------------------------------------------------------------
	# Build base image for all buildenvs
	cd buildenv-base
	ls -la
	bash run-docker.sh

	# ---------------------------------------------------------------
	# Go back to winlin dir
	cd ..

	# ---------------------------------------------------------------
	# Start ubuntu slave
	cd ubuntu
	ls -la
	bash run-docker.sh

	# ---------------------------------------------------------------
	# Go back to winlin dir
	cd ..

	# ---------------------------------------------------------------
	# Start windows slave (wine):
	cd wine
	ls -la
	bash run-docker.sh

# -------------------------------------------------------------------
# Wait for docker to startup:
sleep 10

EOF