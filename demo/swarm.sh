if [ ! -f swarmtool-2017.12.1-standalone.jar ]; then
   wget https://repo1.maven.org/maven2/org/wildfly/swarm/swarmtool/2017.12.1/swarmtool-2017.12.1-standalone.jar
fi
/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home/bin/java -jar swarmtool-2017.12.1-standalone.jar -d com.h2database:h2:1.4.196 target/ticket-monster.war
heroku config:set --app ticket-monster JAVA_OPTS="-XX:+UseCompressedOops -Xmx92m -Xss228k -XX:MaxMetaspaceSize=110m"
heroku deploy:jar ticket-monster-swarm.jar --app ticket-monster --options '-Dswarm.http.port=$PORT'
heroku logs --app ticket-monster --tail
