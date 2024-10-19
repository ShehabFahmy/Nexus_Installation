pipeline {
    agent { label 'master' }
    environment {
        JENKINS_URL = 'http://localhost:8080'
        JENKINS_CLI_JAR = 'jenkins-cli.jar'
        JENKINS_USER = 'sheko'          // Jenkins username
        JENKINS_API_TOKEN = '11bba78624db4fc3239c1a1752d5db839f'    // Jenkins API token
        NODE_NAME = 'ansible-and-nexus-agent'     // Name of the agent to create
        SSH_CRED_ID = 'my-rsa-key'                // SSH credential ID
        REMOTE_FS = '/home/ubuntu/jenkins_agent'  // Remote file system for agent
        JAVA_PATH = '/usr/bin/java'               // Path to Java on the EC2 instance
    }
    stages {
        stage('Launch Ansible-and-Nexus Agent') {
            steps {
                // In the terraform directory
                dir('/home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform/Terraform') {
                    // Use Terraform to create the AWS infrastructure
                    script {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'

                        // Capture the public IP of the EC2 instance
                        env.PUBLIC_IP = sh(script: "terraform output -raw ec2-public-ip", returnStdout: true).trim()

                        // Print the captured public IP
                        echo "The public IP of the EC2 instance is: ${env.PUBLIC_IP}"
                    }
                }
            }
        }
        
        // stage('Push to GitHub') {
        //     steps {
        //         dir('/home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform') {
        //             withCredentials([sshUserPrivateKey(credentialsId: "my-ssh-key", keyFileVariable: 'SSH_KEY')]) {
        //                 // Configure the directory as a safe directory
        //                 sh 'git config --global --add safe.directory /home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform'

        //                 // Set user name and email for Git
        //                 sh 'git config --global user.email "shehabmostafa2323@gmail.com"'
        //                 sh 'git config --global user.name "ShehabFahmy"'

        //                 sh '''
        //                     git add Ansible/
        //                     git commit -m "Running Pipeline - ${JOB_NAME} - Build #${BUILD_NUMBER}"
                            
        //                     export GIT_SSH_COMMAND="ssh -i ${SSH_KEY} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

        //                     # Push the changes using the custom SSH command
        //                     git push git@github.com:ShehabFahmy/Nexus_Installation.git main
        //                 '''
        //             }
        //         }
        //     }
        // }

        stage('Configure EC2 as Jenkins Agent via CLI') {
            steps {
                script {
                    // Check if the node exists and delete it if it does (since the host/IP of agent changes with the instance)
                    sh """
                        java -jar ${JENKINS_CLI_JAR} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_API_TOKEN} get-node ${NODE_NAME} > /dev/null 2>&1 && \
                        java -jar ${JENKINS_CLI_JAR} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_API_TOKEN} delete-node ${NODE_NAME} || echo "Node does not exist."
                    """

                    // Download Jenkins CLI
                    sh 'curl -O ${JENKINS_URL}/jnlpJars/${JENKINS_CLI_JAR}'
                    
                    // Add the EC2 instance as a new agent using the public IP                        
                    sh """
                        java -jar ${JENKINS_CLI_JAR} -s ${JENKINS_URL} -auth ${JENKINS_USER}:${JENKINS_API_TOKEN} create-node ${NODE_NAME} <<EOF
                        <slave>
                            <name>${NODE_NAME}</name>
                            <description>EC2 Agent launched by pipeline</description>
                            <remoteFS>${REMOTE_FS}</remoteFS>
                            <numExecutors>1</numExecutors>
                            <label>ansible-and-nexus-agent</label>
                            <mode>NORMAL</mode>
                            <retentionStrategy class="hudson.slaves.RetentionStrategy\$Always"/>
                            <launcher class="hudson.plugins.sshslaves.SSHLauncher">
                                <host>${PUBLIC_IP}</host>
                                <port>22</port>
                                <credentialsId>${SSH_CRED_ID}</credentialsId>
                                <javaPath>${JAVA_PATH}</javaPath>
                                <launchTimeoutSeconds>60</launchTimeoutSeconds>
                                <maxNumRetries>5</maxNumRetries>
                                <sshHostKeyVerificationStrategy class="hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy"/>  <!-- Non-verifying strategy -->
                            </launcher>
                            <nodeProperties/>
                        </slave>
                        EOF
                    """
                }
            }
        }
        
        stage('Run Job on Slave') {
            agent {
                label 'ansible-and-nexus-agent'
            }
            steps {
                script {
                    // Now, you can run tasks on the dynamically configured Jenkins agent (slave)
                    sh 'touch /home/ubuntu/success.txt'
                }
            }
        }
    }
}
