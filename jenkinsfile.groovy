def terra_file_test = 
def secrets = {}

node('slave') {
    stage('retrieving code from git') {
        git 'https://github.com/Salimpossible/Projet_final.git'
    }
    stage('Launching a terraform container') {
        sh ''' 
        cd ${terra_file_test}
        docker run -it -v $(pwd):/workpace -w /workpace hashicorp/terraform:light plan
        '''
    }

    stage('Creating the test environment') {
        sh '''
        cd ${terra_file_test} 
        terraform init 
        terraform apply -var-file=${secrets}
        '''
    }
    stage('Provisionning of the Mongo-DB client') {
        sh docker run -it -v $(pwd):/workpace -w /workpace ansible/ansible:centos7  ansible-playbook 
    }
}

