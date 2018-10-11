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
                    mvn -Dmaven.test.skip=true package
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
        		sh """
        			whoami
        			docker build --build-arg jar_file=${WORKSPACE}/demo/ticket-monster.2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER}.jar .
        		"""
			}
        }
        stage ('UI Testing') {
            steps {
                withCredentials([
                  string(credentialsId: 'OctopusAPIKey', variable: 'APIKey'),
                  string(credentialsId: 'OctopusServer', variable: 'OctopusServer')
                ]) {
                    sh """
                        ${tool('Octo CLI')}/Octo create-channel \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey} \
                            --update-existing \
                            --channel ${env.BRANCH_NAME} \
                            --project UITesting
                        ${tool('Octo CLI')}/Octo push \
                            --package ${WORKSPACE}/demo/ticket-monster.2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER}.jar \
                            --replace-existing \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey}
                        ${tool('Octo CLI')}/Octo create-release \
                            --project UITesting \
                            --channel ${env.BRANCH_NAME} \
                            --ignoreexisting \
                            --package ticket-monster:2.7.0-${env.BRANCH_NAME}.${env.BUILD_NUMBER} \
                            --version 1.0.${env.BUILD_NUMBER} \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey}
                        ${tool('Octo CLI')}/Octo deploy-release \
                            --project UITesting \
                            --channel ${env.BRANCH_NAME} \
                            --version 1.0.${env.BUILD_NUMBER} \
                            --deploymenttimeout 01:00:00 \
                            --deployto Testing \
                            --waitfordeployment \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey}
                    """
                }
            }
        }
    }
}
