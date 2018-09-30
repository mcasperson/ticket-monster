#!/usr/bin/env bash
heroku config:set --app ticket-monster JAVA_OPTS="-XX:+UseCompressedOops -Xmx128m -Xss228k -XX:MaxMetaspaceSize=128m"
heroku deploy:jar ticket-monster-swarm.jar --app ticket-monster --options '-Dswarm.http.port=$PORT'
heroku logs --app ticket-monster --tail