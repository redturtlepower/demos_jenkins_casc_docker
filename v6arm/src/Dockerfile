### BUILD jenkins for ARM
### based on https://github.com/djdefi/rpi-jenkins/blob/master/Dockerfile

#FROM --platform=$TARGETPLATFORM arm32v7/openjdk:latest
#ARG TARGETPLATFORM

FROM arm32v7/openjdk:latest

RUN apt-get update; apt-get --yes install \
    apt-transport-https \
    curl \
    nano \
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

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV REF $REF

RUN mkdir -p $JENKINS_HOME \
 && useradd --no-create-home --shell /bin/sh ${user} \
 && chown -R ${user}:${group} $JENKINS_HOME

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# $REF (defaults to `/usr/share/jenkins/ref/`) contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p ${REF}/init.groovy.d

ENV JENKINS_VERSION 2.222.3

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R ${user} "$JENKINS_HOME" "$REF"

# for main web interface:
EXPOSE ${agent_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

USER root

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log
RUN curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support > /usr/local/bin/jenkins-support \
 && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh > /usr/local/bin/jenkins.sh \
# && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/plugins.sh > /usr/local/bin/plugins.sh \
 && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh > /usr/local/bin/install-plugins.sh \
 && chmod +x /usr/local/bin/install-plugins.sh \
 && chmod +x /usr/local/bin/jenkins-support \
 && chmod +x /usr/local/bin/jenkins.sh

USER ${user}

# Change URL for use behind a reserve proxy
ENV JENKINS_OPTS "--prefix=/jenkins"
ENV CASC_JENKINS_CONFIG "${JENKINS_HOME}/casc_configs/jenkins.yaml"

COPY casc_configs/jenkins.yaml ${REF}/casc_configs/jenkins.yaml
COPY plugins.txt ${REF}/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat ${REF}/plugins.txt)

# Avoid banner prompting user to install additional plugins
RUN echo 2.0 > ${REF}/jenkins.install.UpgradeWizard.state

RUN /usr/local/bin/jenkins-support

#CMD ["/usr/bin/java", "-jar", "/usr/share/jenkins/jenkins.war"]
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
