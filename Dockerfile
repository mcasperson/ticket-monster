FROM openjdk:8
EXPOSE 5000
ARG jar_file
COPY $jar_file /opt/ticketmonster.jar
CMD java -jar /opt/ticketmonster.jar