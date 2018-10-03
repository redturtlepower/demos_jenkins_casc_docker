FROM jenkins/jenkins:lts-alpine

# Change URL for use behind a reserve proxy
ENV JENKINS_OPTS "--prefix=/jenkins"

# Install init.d groovy scripts
# Reference: https://wiki.jenkins.io/display/JENKINS/Configuring+Jenkins+upon+start+up
# Reference: https://wiki.jenkins.io/display/JENKINS/Post-initialization+script
# Reference: https://wiki.jenkins.io/display/JENKINS/Groovy+Hook+Script
# COPY ./init.groovy.d/load-properties.groovy /usr/share/jenkins/ref/init.groovy.d/load-properties.groovy


# Install initially required plugins from plugins.txt via the script install-plugins.sh
#COPY install-plugins.sh /usr/local/bin/install-plugins.sh
#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
#USER root
#RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)
#USER jenkins
# COPY install-plugins.sh /usr/share/jenkins/ref/install-plugins.sh
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
USER root
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)
USER jenkins

# Avoid banner prompting user to install additional plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
