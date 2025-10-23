FROM tomcat:10.1-jdk11-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/ClinicaDentalApp-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war
