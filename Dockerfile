# FROM centos:latest
FROM openshift/base-centos7
MAINTAINER akatbo@gmail.com

# RUN yum install -y java wget mvn --setopt=tsflags=nodocs && yum -y clean all

# RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar xzf - -C /usr/share \
#     && mv /usr/share/apache-maven-3.5.4 /usr/share/maven  \
#     && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# ENV JAVA_HOME /usr/lib/jvm/java
# ENV MAVEN_HOME /usr/share/maven

ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.5.4

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

LABEL io.k8s.description="Platform for building and running Java8 applications" \
      io.k8s.display-name="Java8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,java8" \
      io.openshift.s2i.destination="/opt/app" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i

# RUN adduser --system -u 10001 javauser

RUN adduser --system -u 10001

RUN mkdir -p /opt/app  && chown -R 10001: /opt/app

# RUN mkdir -p /opt/app  && chown -R 1001:0 /opt/app

COPY ./S2iScripts/ /usr/local/s2i

# RUN chown -R 1001:0 ./

USER 10001

EXPOSE 8080

CMD ["/usr/local/s2i/usage"]
