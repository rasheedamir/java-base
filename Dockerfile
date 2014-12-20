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

Docker Image # 1

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

