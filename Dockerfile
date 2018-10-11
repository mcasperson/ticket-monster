FROM openjdk:8
EXPOSE 5000
ENV JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"
ARG jar_file
COPY $jar_file /opt/ticketmonster.jar
CMD java -jar /opt/ticketmonster.jar