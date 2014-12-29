++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Docker Image # 1

FROM totem/totem-base:trusty

ENV JAVA_VERSION 7
 
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget curl g++ make libc6-dev patch git-core openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jre-headless maven

RUN grep '^networkaddress.cache.ttl=' /etc/java-$JAVA_VERSION-openjdk/security/java.security || echo 'networkaddress.cache.ttl=60' >> /etc/java-$JAVA_VERSION-openjdk/security/java.security
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENTRYPOINT ['java']
CMD ['-version']

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Docker Image # 2

#
# OpenJDK Java 7 JRE Dockerfile
#
# https://github.com/dockerfile/java
# https://github.com/dockerfile/java/tree/master/openjdk-7-jre
#

# Pull base image.
FROM dockerfile/ubuntu

# Install Java.
RUN \
  apt-get update && \
  apt-get install -y openjdk-7-jre && \
  rm -rf /var/lib/apt/lists/*

# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Define default command.
CMD ["bash"]

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Docker Image # 3

FROM dockerfile/java:oracle-java8 
 
# Install maven
RUN apt-get update
RUN apt-get install -y maven
 
WORKDIR /code
 
# Prepare by downloading dependencies
ADD pom.xml /code/pom.xml
RUN ["mvn", "dependency:resolve"]
RUN ["mvn", "verify"]
 
# Adding source, compile and package into a fat jar
ADD src /code/src
RUN ["mvn", "package"]
 
EXPOSE 4567
CMD ["java", "-jar", "target/sparkexample-jar-with-dependencies.jar"]

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

https://github.com/phusion/baseimage-docker

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Docker Image # 4

FROM dockerfile/java:oracle-java7
MAINTAINER Nicholas Iaquinto <nickiaq@gmail.com>

# In case someone loses the Dockerfile
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

# Install Grails
WORKDIR /usr/lib/jvm
RUN wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-2.4.4.zip && \
    unzip grails-2.4.4.zip && \
    rm -rf grails-2.4.4.zip && \
    ln -s grails-2.4.4 grails

ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH

# Create App Directory
RUN mkdir /app
WORKDIR /app

# Set Default Behavior
ENTRYPOINT ["grails"]
CMD ["-version"]

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Docker Image # 5

FROM phusion/baseimage:0.9.13
MAINTAINER Manuel Ortiz Bey <ortiz.manuel@mozartanalytics.com>

# Set customizable env vars defaults.
ENV GRAILS_VERSION 2.4.4

# Set phusion/baseimage's correct settings.
ENV HOME /root

# Disable phusion/baseimage's ssh server (not necessary for this type of container).
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Download Install Java
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk unzip wget

# Setup Java Paths
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Install Grails
WORKDIR /usr/lib/jvm
RUN wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-$GRAILS_VERSION.zip
RUN unzip grails-$GRAILS_VERSION.zip
RUN rm -rf grails-$GRAILS_VERSION.zip
RUN ln -s grails-$GRAILS_VERSION grails

# Setup Grails path.
ENV GRAILS_HOME /usr/lib/jvm/grails
ENV PATH $GRAILS_HOME/bin:$PATH

# Create App Directory
WORKDIR /
RUN mkdir /app
WORKDIR /app

# Clean up APT.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Default Behavior
# Use phusion/baseimage's init system.
# See http://phusion.github.io/baseimage-docker/ for more info.
ENTRYPOINT ["/sbin/my_init", "grails"]
CMD ["prod", "run-war"]

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
