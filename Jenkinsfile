def registry = 'https://valaxy2114.jfrog.io'
pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
    }
    stages {
        stage('Build') {
            steps {
                echo '------ build started ------'
                sh 'mvn clean deploy -Dmaven.test.skip=true' // skip unit test
                echo '------ build completed ------'
            }
        }
        stage('test') {
            steps {
                echo '------ unit test started ------'
                sh 'mvn surefire-report:report'
                echo '------ unit test completed ------'
            }
        }
        stage('SonarQube analysis') {
            environment {
                scannerHome = tool 'valaxy-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('valaxy-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') { // tell pipeline to wait for sonar analysis
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Jar Publish') {
            steps {
                // script {
                //     echo '<--------------- Jar Publish Started --------------->'
                //     def server = Artifactory.newServer url:registry + '/artifactory' ,  credentialsId:'artifactory'
                //     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                //     def uploadSpec = """{
                //         "files": [
                //             {
                //             "pattern": "jarstaging/(*)",
                //             "target": "libs-release-local/{1}",
                //             "flat": "false",
                //             "props" : "${properties}",
                //             "exclusions": [ "*.sha1", "*.md5"]
                //             }
                //         ]
                //     }"""
                //     def buildInfo = server.upload(uploadSpec)
                //     buildInfo.env.collect()
                //     server.publishBuildInfo(buildInfo)
                //     echo '<--------------- Jar Publish Ended --------------->'
                // }
                rtServer(
                    id: 'artifactory-instance',
                    url: 'https://valaxy2114.jfrog.io',
                        // If you're using username and password:
                        // username: 'user',
                        // password: 'password',
                        // If you're using Credentials ID:
                        credentialsId: 'artifactory'
                // If Jenkins is configured to use an http proxy, you can bypass the proxy when using this Artifactory server:
                // bypassProxy: true,
                // Configure the connection timeout (in seconds).
                // The default value (if not configured) is 300 seconds:
                // timeout: 300
                )
                rtUpload(
                    serverId: 'artifactory-instance',
                    spec: '''{
                        "files": [
                            {
                            "pattern": "jarstaging/(*)",
                            "target": "libs-release-local/"
                            }
                        ]
                    }'''

                    // Optional - Associate the uploaded files with the following custom build name and build number,
                    // as build artifacts.
                    // If not set, the files will be associated with the default build name and build number (i.e the
                    // the Jenkins job name and number).
                    // buildName: 'holyFrog',
                    // buildNumber: '42',
                    // Optional - Only if this build is associated with a project in Artifactory, set the project key as follows.
                    // project: 'my-project-key'
                )
            }
        }
    }
}
