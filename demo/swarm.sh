#!/usr/bin/env bash
if [ ! -f swarmtool-2.2.0.Final-standalone.jar ]; then
   wget https://repo1.maven.org/maven2/io/thorntail/swarmtool/2.2.0.Final/swarmtool-2.2.0.Final-standalone.jar
fi
/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home/bin/java -jar swarmtool-2.2.0.Final-standalone.jar -d com.h2database:h2:1.4.196 -d mysql:mysql-connector-java:5.1.45 target/ticket-monster.war
heroku config:set --app ticket-monster JAVA_OPTS="-XX:+UseCompressedOops -Xmx128m -Xss228k -XX:MaxMetaspaceSize=128m"
heroku deploy:jar ticket-monster-swarm.jar --app ticket-monster --options '-Dswarm.http.port=$PORT'
heroku logs --app ticket-monster --tail
