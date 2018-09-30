#!/usr/bin/env bash
if [ ! -f swarmtool-2.2.0.Final-standalone.jar ]; then
   wget https://repo1.maven.org/maven2/io/thorntail/swarmtool/2.2.0.Final/swarmtool-2.2.0.Final-standalone.jar
fi
java -jar swarmtool-2.2.0.Final-standalone.jar \
    -d com.h2database:h2:1.4.196 \
    -d mysql:mysql-connector-java:5.1.45 \
    target/ticket-monster.war

