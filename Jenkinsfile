node('slave'){
    stage('création infra'){
        
            docker.image('aaugrain/terra-git:latest').inside() {
                sh  'ls -l'
                try {
                sh 'mv terraformServTestDB/terraform.tfstate* .'
                }
                catch (exc){
                    echo 'pas de tf state'
                   
                }
                git 'https://github.com/Salimpossible/Projet_final.git'
                try {
                sh 'mv terraform.tfstate* terraformServTestDB/'
                }
                catch (exc){
                    echo 'pas de tf state'
                
                }
                sh 'ls'
                withCredentials([file(credentialsId: '45ea5915-31ad-4764-b8e9-0487396d9d1d', variable: 'secret')]) {
                    //sh 'terraform init'
                    //sh 'terraform -v'
                    sh '''
                    cd terraformServTestDB/
                    terraform init
                    terraform plan -var-file=$secret -var-file=variables/main.tfvars
                    terraform apply -auto-approve -var-file=$secret -var-file=variables/main.tfvars
                    '''
                }
            }
    }    
            
    stage('build'){      
                git 'https://github.com/aaugrain/Restful-Webservice.git'
                sh '''
                pwd
                ls
                '''
                sh "mvn clean package"
                sh 'pwd'
                sh 'cp target/restfulweb-1.0.0-SNAPSHOT.jar /home/stage'
    }
    stage('deploiement sur le serveur test') {
        withCredentials([sshUserPrivateKey(credentialsId: '0f9059ce-d30e-4d9a-871e-5f0fd5a80380', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'stage')]) {
            sh 'cat \$Key > ~/.ssh/id_rsa'
            sh 'chmod 600 ~/.ssh/id_rsa'
            sh 'scp -o StrictHostKeyChecking=no /home/stage/restfulweb-1.0.0-SNAPSHOT.jar stage@dnsenvtest.francecentral.cloudapp.azure.com:/home/stage/'
        }
    }
    
    stage('check the working space'){
        sh 'ls'
    }
    docker.image('aaugrain/ansible-git:latest').inside('-u root') {
        stage('recup git'){
            git 'https://github.com/Salimpossible/Projet_final.git'
        }
        
        withCredentials([sshUserPrivateKey(credentialsId: '0f9059ce-d30e-4d9a-871e-5f0fd5a80380', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'stage')]) {   
            sh 'cat \$Key > ~/.ssh/id_rsa'
            sh 'chmod 600 ~/.ssh/id_rsa'
        }
        stage('exec playbook'){
            sh "ansible-playbook ansible/install_pile.yml -i ansible/inventory"
        }
    }

    // if (env.git_branch == 'master'){
    //     stage('Deploy JAR on server prod') {
    //         sh "echo 'branche de prod'"
    //         withCredentials([sshUserPrivateKey(credentialsId: '0f9059ce-d30e-4d9a-871e-5f0fd5a80380', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'stage')]) {
    //             sh 'cat \$Key > ~/.ssh/id_rsa'
    //             sh 'chmod 600 ~/.ssh/id_rsa'
    //             sh 'scp /home/stage/restfulweb-1.0.0-SNAPSHOT.jar stage@dnsenvtest.francecentral.cloudapp.azure.com:/home/stage/'
    //             sh '''
    //             ssh -f stage@dnsenvtest.francecentral.cloudapp.azure.com 'java -jar /home/stage/restfulweb-1.0.0-SNAPSHOT.jar -spring.data.mongodb.uri=$MONGO_DB ://$MONGO_ADMIN :$MONGO_PWD@$MONGO_URL :$MONGO_PORT'
    //             '''
    //         }   
    //     }
    // }

    // if (env.git_branch == 'devel')
    // {
    //     stage('Deploy JAR on server test') {
    //         sh "echo 'branche de test'"
    //         withCredentials([sshUserPrivateKey(credentialsId: '0f9059ce-d30e-4d9a-871e-5f0fd5a80380', keyFileVariable: 'Key', passphraseVariable: '', usernameVariable: 'stage')]) {
    //         sh 'cat \$Key > ~/.ssh/id_rsa'
    //             sh 'chmod 600 ~/.ssh/id_rsa'
    //             sh 'scp /home/stage/restfulweb-1.0.0-SNAPSHOT.jar stage@dnsenvprod.francecentral.cloudapp.azure.com:/home/stage/'
    //             sh '''
    //             ssh -f stage@dnsenvprod.francecentral.cloudapp.azure.com 'java -jar /home/stage/restfulweb-1.0.0-SNAPSHOT.jar -spring.data.mongodb.uri=$MONGO_DB ://$MONGO_ADMIN :$MONGO_PWD@$MONGO_URL :$MONGO_PORT'
    //             '''
    //         }
    //     }
    // }
}
