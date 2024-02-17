pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    stages {
        stage('Clone source code') {
            steps {
                git branch: 'main', url: 'https://github.com/lukeNonyane1/tweet-trend-new-devops-workshop.git'
            }
        }
    }
}
