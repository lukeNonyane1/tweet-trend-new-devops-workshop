pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    stages {
        stage('Build') {
            steps {
                withEnv(['PATH=$PATH:/opt/apache-maven-3.9.6/bin']) {
                    sh 'mvn clean deploy'
                }
            }
        }
    }
}
