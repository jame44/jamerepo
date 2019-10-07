pipeline {
    agent any
    environment {
        MY_WORKSPACE = ""
        runner = "pwd"
    }
    stages {
        stage('First') {
            steps {
                powershell 'echo first'
                script
                {   
                    MY_WORKSPACE = WORKSPACE

                }
            }
            post
            {
                always
                {
                    node('script')
                    {
                        dir(MY_WORKSPACE) {
                            script
                            {
                                bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile Select-String -Path .\\tools\\build.txt -Pattern '-kukaracha:' -Context 5 > message.txt"
                                postStatus("message.txt")
                            }
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
                dir(MY_WORKSPACE) 
                {
                    bat "echo invoked from first step"
                    bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile pwd"
                    bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile ls"
                    bat "echo Build succeeded > text.txt"
                }
            }
        }
    }
}

void postStatus(LogFile)
{
    withCredentials([string(credentialsId: 'ghprbuilderplugin', variable: 'TOKEN')]) {
        bat "powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile .\\tools\\runner.ps1 -Logfile '${MY_WORKSPACE}\\${LogFile}' -PullRequestId 1 -Token ${TOKEN}"
    }
}
