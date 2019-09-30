pipeline {
    agent any
    stages {
        stage('Bootstrap') {
            steps {
                stash name: 'runner', includes: 'tools/runner.ps1'
            }
        }
        stage('First') {
            steps {
                powershell 'echo first'
                stash name: 'test', includes: 'text.txt'
            }
            post
            {
                always
                {
                    node('script')
                    {
                        script
                        {
                            unstash name: 'test'
                            archiveArtifacts artifacts: 'text.txt', allowEmptyArchive: true
                        }
                    }
                }
                success
                {
                    node('script')
                    {
                        script
                        {
                            unstash name: 'runner'
                            postStatus("text.txt")
                        }
                    }
                }                
            }            
        }
        stage('Second') {
            steps {
                powershell 'echo second'
                stash name: 'serverlog', includes: 'serverlog.txt'
            }
            post
            {
                always
                {
                    node('script')
                    {
                        script
                        {
                            unstash name: 'serverlog'
                            archiveArtifacts artifacts: 'serverlog.txt', allowEmptyArchive: true
                        }
                    }
                }
                success
                {
                    node('script')
                    {
                        script
                        {
                            unstash name: 'runner'
                            postStatus("serverlog.txt")
                        }
                    }
                }                
            }            
        }        
    }
    post {
        success
        {
            node('script')
            {
                unstash name: 'runner'
                unstash name: 'serverlog'
                unstash name: 'test'
                bat "type  *.txt > buildlog.txt"
                postTemp()
                bat "log.txt > buildlog.txt"
                archiveArtifacts artifacts: 'buildlog.txt', allowEmptyArchive: true
                bat "echo Build succeeded > text.txt"
                postStatus("text.txt")
            }
        }
    }
}

void postStatus(LogFile)
{
    withCredentials([string(credentialsId: 'ghprbuilderplugin', variable: 'TOKEN')]) {
        bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile .\\tools\\runner.ps1 -Logfile '${WORKSPACE}\\${LogFile}' -PullRequestId 1 -Token ${TOKEN}"
    }
}

void postTemp() 
{
    withCredentials([usernamePassword(credentialsId: '2e2accd9-7150-4f79-8450-88f7d3afc050', passwordVariable: '', usernameVariable: '')]) {
       bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile curl '${BUILD_URL}/consoleText' -O log.txt --user 'username:password'"

}

void prepareArtifacts(LogFile)
{
    unstash name: 'runner'
    unstash name: ${LogFile}
    archiveArtifacts artifacts: ${LogFile}+".txt", allowEmptyArchive: true
}
