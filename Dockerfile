FROM openjdk:8
EXPOSE 5000
ARG jar_file
COPY $jar_file /opt/ticketmonster.jar
CMD java -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -jar /opt/ticketmonster.jar