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
                    mv ticket-monster ticket-monster.2.7.0.${env.BUILD_NUMBER}-${env.BRANCH_NAME}.jar
                """
            }
        }
        stage ('Deploy to Octopus') {
            steps {
                withCredentials([
                  string(credentialsId: 'OctopusAPIKey', variable: 'APIKey'),
                  string(credentialsId: 'OctopusServer', variable: 'OctopusServer')
                ]) {
                    sh """
                        cd demo
                        ${tool('Octo CLI')}/Octo create-channel \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey} \
                            --update-existing \
                            --channel ${env.BRANCH_NAME} \
                            --project UITesting
                        ${tool('Octo CLI')}/Octo push \
                            --package ${WORKSPACE}/demo/ticket-monster.2.7.0.${env.BUILD_NUMBER}-${env.BRANCH_NAME}.jar \
                            --replace-existing \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey}
                        ${tool('Octo CLI')}/Octo create-release \
                            --project UITesting \
                            --channel ${env.BRANCH_NAME} \
                            --ignoreexisting \
                            --server ${OctopusServer} \
                            --apiKey ${APIKey}
                        ${tool('Octo CLI')}/Octo deploy-release \
                            --project UITesting \
                            --channel ${env.BRANCH_NAME} \
                            --version 2.7.0.${env.BUILD_NUMBER}-${env.BRANCH_NAME} \
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
