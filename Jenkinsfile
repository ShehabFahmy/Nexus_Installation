pipeline {
    agent { label 'master' }
    stages {
        // stage('Launch Ansible-and-Nexus Agent'){
        //     steps {
        //         // In the terraform directory
        //         dir('/home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform/Terraform') {
        //             // Use Terraform to create the AWS infrastructure
        //             sh 'terraform init'
        //             sh 'terraform apply -auto-approve'
        //         }
        //     }
        // }
        
        stage('Push to GitHub') {
            steps {
                dir('/home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform') {
                    withCredentials([sshUserPrivateKey(credentialsId: "my-ssh-key", keyFileVariable: 'SSH_KEY')]) {
                        // Configure the directory as a safe directory
                        sh 'git config --global --add safe.directory /home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform'

                        // Set user name and email for Git
                        sh 'git config --global user.email "shehabmostafa2323@gmail.com"'
                        sh 'git config --global user.name "ShehabFahmy"'

                        sh '''
                            git add Ansible/
                            git commit -m "Running Pipeline - ${JOB_NAME} - Build #${BUILD_NUMBER}"
                            
                            export GIT_SSH_COMMAND="ssh -i ${SSH_KEY} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

                            # Push the changes using the custom SSH command
                            git push git@github.com:ShehabFahmy/Nexus_Installation.git main
                        '''
                    }

                    // script {


                    //     // Initialize git repo only if it's not already a repo
                    //     sh """
                    //     if [ ! -d ".git" ]; then
                    //         git init
                    //     fi
                    //     """

                    //     // Set or update remote URL
                    //     sh """
                    //     if git remote | grep -q origin; then
                    //         git remote set-url origin git@github.com:ShehabFahmy/Nexus_Installation.git
                    //     else
                    //         git remote add origin git@github.com:ShehabFahmy/Nexus_Installation.git
                    //     fi
                    //     """

                    //     // Stage, commit, and push changes
                    //     sh """
                    //     git add .
                    //     git commit -m 'Running Pipeline - ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}'
                    //     git push origin main
                    //     """
                    // }
                }
            }
        }

        // stage('Configure Slave') {
        //     steps {
        //         script {
        //             // Copy the private key to a file
        //             writeFile file: '/tmp/jenkins_private_key', text: env.SSH_PRIVATE_KEY
        //             sh 'chmod 600 /tmp/jenkins_private_key'

        //             // Use the dynamic SSH key to connect to the new EC2 instance and configure it as a Jenkins agent
        //             sshagent(credentials: []) {
        //                 // Assuming 'ec2-user' is the default user for the AMI you're using
        //                 sh '''
        //                     ssh -o StrictHostKeyChecking=no -i /tmp/jenkins_private_key ec2-user@${EC2_IP} \
        //                     'wget http://your-jenkins-server/jnlpJars/agent.jar && java -jar agent.jar -jnlpUrl http://your-jenkins-server/computer/slave-name/slave-agent.jnlp'
        //                 '''
        //             }
        //         }
        //     }
        // }
        
        // stage('Run Job on Slave') {
        //     agent {
        //         label 'slave-label'
        //     }
        //     steps {
        //         script {
        //             // Now, you can run tasks on the dynamically configured Jenkins agent (slave)
        //             sh 'ansible-playbook -i inventory.yaml playbook.yml'
        //         }
        //     }
        // }
    }
}
