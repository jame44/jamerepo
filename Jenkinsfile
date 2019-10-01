pipeline {
    agent any
    stages {
        stage('Bootstrap') {
            steps {
                stash name: 'runner', includes: 'tools/runner.ps1'
                stash name: 'downloader', includes: 'tools/downloader.ps1'                
            }
        }
        stage('First') {
            steps {
                powershell 'echo first'
                script
                {               
                    try
                    {
                        bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile .\\run.ps1 > text.txt 2>&1"
                    }
                    catch (Exception e)
                    {
                        throw e
                    }
                    finally
                    {
                        stash name: 'test', includes: 'text.txt'
                    }
                }
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
                failure
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
                failure
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
                unstash name: 'downloader'
                unstash name: 'serverlog'
                unstash name: 'test'
                bat "type  *.txt > buildlog.txt"
                postTemp()
                archiveArtifacts artifacts: 'log.txt', allowEmptyArchive: true
                bat "echo Build succeeded > text.txt"
                postStatus("log.txt")
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
    withCredentials([usernamePassword(credentialsId: 'jenkinsauth', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
        
        bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile .\\tools\\downloader.ps1 -Username ${USERNAME} -Password ${PASSWORD} -Url ${BUILD_URL}/consoleText"
    }
}

void prepareArtifacts(LogFile)
{
    unstash name: 'runner'
    unstash name: ${LogFile}
    archiveArtifacts artifacts: ${LogFile}+".txt", allowEmptyArchive: true
}
