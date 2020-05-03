### BUILD jenkins for ARM
### based on https://github.com/djdefi/rpi-jenkins/blob/master/Dockerfile

#FROM --platform=$TARGETPLATFORM arm32v7/openjdk:latest
#ARG TARGETPLATFORM

FROM arm32v7/openjdk:latest

EXPOSE 8080

RUN apt-get update; apt-get --yes install \
    apt-transport-https \
    curl \
    git \
    ca-certificates \
    gnupg-agent \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get --yes install \
    docker-ce docker-ce-cli containerd.io && \
    apt-get clean && apt-get autoremove -q && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man /tmp/*

ENV JENKINS_HOME /usr/local/jenkins

RUN mkdir -p /usr/local/jenkins
RUN useradd --no-create-home --shell /bin/sh jenkins 
RUN chown -R jenkins:jenkins /usr/local/jenkins/
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /usr/local/jenkins.war
RUN chmod 644 /usr/local/jenkins.war

CMD ["/usr/bin/java", "-jar", "/usr/local/jenkins.war"]

### END OF JENKINS ARM BUILD ###
###################################################################

# Change URL for use behind a reserve proxy
ENV JENKINS_OPTS "--prefix=/jenkins"

ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs/jenkins.yaml"

# Install init.d groovy scripts
# Reference: https://wiki.jenkins.io/display/JENKINS/Configuring+Jenkins+upon+start+up
# Reference: https://wiki.jenkins.io/display/JENKINS/Post-initialization+script
# Reference: https://wiki.jenkins.io/display/JENKINS/Groovy+Hook+Script
# COPY ./init.groovy.d/load-properties.groovy /usr/share/jenkins/ref/init.groovy.d/load-properties.groovy
# COPY ./init.groovy.d/set-env-vars.groovy /usr/share/jenkins/ref/init.groovy.d/set-env-vars.groovy 

COPY casc_configs/jenkins.yaml /usr/share/jenkins/ref/casc_configs/jenkins.yaml

# Install initially required plugins from plugins.txt via the script install-plugins.sh
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
USER root
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)
USER jenkins

# Avoid banner prompting user to install additional plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
