def tfstate = {}
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
    }
    
    stage('check the working space'){
        sh 'ls'
    }
    stage('provisioning of the mongodb host'){
        docker.image('aaugrain/ansible-git:1.0').inside() {
            sh "ansible-playbook ansible/install_pil.yml -i ansible/inventory"
        }
    }

    stage('deployment'){
        when {
            branch 'master'
        }
        sh 'scp target/lejar stage@server_test:/home/stage/'
    }
    
}