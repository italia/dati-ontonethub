# BUILD_IMAGE
FROM maven:3.6-jdk-8-slim as BUILD_IMAGE

RUN mkdir -p /ontonethub

COPY src /ontonethub

WORKDIR /ontonethub/indexing
RUN ["mvn", "clean", "package"]

RUN ["mv", "target/indexing-genericrdf-0.1.jar", "../api/src/main/resources/executables/indexing-genericrdf.jar"]

WORKDIR /ontonethub
RUN ["mvn", "clean", "package"]

# APP
FROM tomcat:8.5

WORKDIR /usr/local/tomcat
RUN ["rm", "-rf", "/usr/local/tomcat/webapps/stanbol*"]
COPY --from=BUILD_IMAGE /ontonethub/war/target/stanbol.war /usr/local/tomcat/webapps/

ENTRYPOINT ["/usr/local/tomcat/bin/catalina.sh", "run"]
