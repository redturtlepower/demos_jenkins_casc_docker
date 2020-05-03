### BUILD jenkins for ARM
### based on https://github.com/djdefi/rpi-jenkins/blob/master/Dockerfile

#FROM --platform=$TARGETPLATFORM arm32v7/openjdk:latest
#ARG TARGETPLATFORM

FROM arm32v7/openjdk:latest

ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

# for main web interface:
EXPOSE ${agent_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

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

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

RUN mkdir -p $JENKINS_HOME
RUN useradd --no-create-home --shell /bin/sh jenkins 
RUN chown -R jenkins:jenkins $JENKINS_HOME
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /usr/local/jenkins.war
RUN chmod 644 /usr/local/jenkins.war

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals

RUN curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support > /usr/local/bin/jenkins-support
RUN curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh > /usr/local/bin/jenkins.sh
RUN curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh > /usr/local/bin/plugins.sh
RUN curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh > /usr/local/bin/install-plugins.sh
RUN chmod +x /usr/local/bin/install-plugins.sh
#COPY install-plugins.sh /usr/local/bin/install-plugins.sh

# Change URL for use behind a reserve proxy
ENV JENKINS_OPTS "--prefix=/jenkins"

ENV CASC_JENKINS_CONFIG "${JENKINS_HOME}/casc_configs/jenkins.yaml"

COPY casc_configs/jenkins.yaml /usr/share/jenkins/ref/casc_configs/jenkins.yaml

# Install initially required plugins from plugins.txt via the script install-plugins.sh
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
USER root
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/ref/plugins.txt)
USER jenkins

# Avoid banner prompting user to install additional plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

CMD ["/usr/bin/java", "-jar", "/usr/local/jenkins.war"]

