pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    stages {
        stage('Build') {
            steps {
                withEnv(['mvn=/opt/apache-maven-3.9.6/bin/mvn']) {
                    sh '$mvn clean deploy'
                }
            }
        }
    }
}
