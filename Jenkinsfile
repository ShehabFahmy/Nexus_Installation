pipeline {
    agent { label 'master' }
    stages {
        stage('Launch Ansible-and-Nexus Agent'){
            steps {
                dir('/home/Installing-Nexus-using-Jenkins-Ansible-and-Terraform/Terraform') {
                    // Use Terraform to create the AWS infrastructure
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        
        stage('Push to GitHub') {
            steps {
                // Clone the GitHub repository using the SSH credentials
                git branch: "${GIT_BRANCH}",
                    url: "${GIT_REPO}",
                    credentialsId: 'your-ssh-credentials-id'  // Use the ID of your SSH credentials
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
