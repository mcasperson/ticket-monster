pipeline {
    agent any
    tools {
        maven 'Maven 3.5.4'
        jdk 'jdk8'
    }
    stages {
        stage ('Package') {
            steps {
                sh """
                    cd demo
                    mvn -Dmaven.test.skip=true -Pmysql package
                    if [ ! -f swarmtool-2.2.0.Final-standalone.jar ]; then
                       wget https://repo1.maven.org/maven2/io/thorntail/swarmtool/2.2.0.Final/swarmtool-2.2.0.Final-standalone.jar
                    fi
                    java -jar swarmtool-2.2.0.Final-standalone.jar \
                        -d com.h2database:h2:1.4.196 \
                        -d mysql:mysql-connector-java:5.1.45 \
                        target/ticket-monster.war
                    mv ticket-monster ticket-monster.2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER}.jar
                """
            }
        }
        stage ('Build Docker Image') {
        	steps {	
        		withCredentials([
        			usernamePassword(credentialsId: 'DockerHub', usernameVariable: 'DockerHubUser', passwordVariable: 'DockerHubPass')
				 ]) {
					sh """
						docker login -u '${DockerHubUser}' -p '${DockerHubPass}'
						docker build --build-arg jar_file=demo/ticket-monster.2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER}.jar -t mcasperson/ticket-monster:2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER} .
						docker push mcasperson/ticket-monster:2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER}
					"""
				}
			}
        }
        stage ('UI Testing') {
            steps {
                withCredentials([
                  string(credentialsId: 'OctopusAPIKey', variable: 'APIKey'),
                  string(credentialsId: 'OctopusServer', variable: 'OctopusServer')
                ]) {
					sh """						
                        ${tool('Octo CLI')}/Octo create-environment \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey} \
                            --ignoreIfExists \
                            --name ${env.BRANCH_NAME}  
						${tool('Octo CLI')}/Octo associate-machine \
							--server ${OctopusServer} \
                            --apiKey ${APIKey} \
							--machine=Google K8S Admin \
							--environment=${env.BRANCH_NAME}						
						${tool('Octo CLI')}/Octo associate-tenant \
							--server ${OctopusServer} \
                            --apiKey ${APIKey} \
							--project=UITesting \
							--environment=${env.BRANCH_NAME} \
							--tenant=Hosted1
						${tool('Octo CLI')}/Octo associate-tenant \
							--server ${OctopusServer} \
                            --apiKey ${APIKey} \
							--project=UITesting \
							--environment=${env.BRANCH_NAME} \
							--tenant=Hosted2
                        ${tool('Octo CLI')}/Octo create-release \
                            --project UITesting \
                            --ignoreexisting \
                            --package ticket-monster:2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER} \
                            --version 1.0.${env.BUILD_NUMBER} \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey} \
                            --tenant Hosted1 \
							--tenant Hosted2
                        ${tool('Octo CLI')}/Octo deploy-release \
                            --project UITesting \
                            --version 1.0.${env.BUILD_NUMBER} \
                            --deploymenttimeout 01:00:00 \
                            --waitfordeployment \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey} \
                            --tenant Hosted1 \
							--tenant Hosted2 \
							--deployto ${env.BRANCH_NAME}
                    """
                }
            }
        }
    }
}
