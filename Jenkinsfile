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
        // stage('Jar Publish') {
        //     steps {
        //         script {
        //             echo '<------ Jar Publish Started ------>'
        //             def server = Artifactory.newServer url:registry + '/artifactory', credentialsId: 'artifactory'
        //             def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
        //             def uploadSpec = """{
        //                 "files": [
        //                     {
        //                         "pattern": "jarstaging/(*)",
        //                         "target": "libs-release-local/{1}",
        //                         "flat": "false",
        //                         "props": "${properties}",
        //                         "exclusions": ["*.sha1", "*.md5"]
        //                     }
        //                 ]
        //             }"""
        //             def buildInfo = server.uploadSpec(uploadSpec)
        //             buildInfo.env.collect()
        //             server.publishBuildInfo(buildInfo)
        //             echo '<------ Jar Publish Completed ------>'
        //         }
        //     }
        // }
        stage('Jar Publish') {
            steps {
                echo '<------ Jar Publish Started ------>'
                rtUpload(
                    /* groovylint-disable-next-line GStringExpressionWithinString */
                    serverId: 'artifactory-instance',
                    spec: '''{
                        "files": [
                            {
                                "pattern": "home/ubuntu/jenkins/workspace/ttrend-multibranch_main/jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar",
                                "target": "libs-release-local",
                                "flat": "false",
                                "props": ["buildid=${env.BUILD_ID}";"commitid=${GIT_COMMIT}"],
                                "excludePatterns": ["*.sha1","*.md5"]
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
                echo '<------ Jar Publish Completed ------>'
            }
        }
    }
}
