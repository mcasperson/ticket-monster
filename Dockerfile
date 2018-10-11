FROM openjdk:8
EXPOSE 5000
ARG jar_file
COPY $jar_file /opt/ticketmonster.jar
RUN java -jar /opt/ticketmonster.jar