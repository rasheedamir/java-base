FROM ubuntu:trusty

ENV JAVA_VERSION 7
 
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y wget curl g++ make libc6-dev patch git-core openjdk-$JAVA_VERSION-jdk openjdk-$JAVA_VERSION-jre-headless maven

RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENTRYPOINT ['java']
CMD ['-version']
