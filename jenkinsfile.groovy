def terra_file_test = 

node('slave') {
    stage('Binding azure credential to variable') {
        withCredentials([file(credentialsId: '6b72eccc-25ec-4538-bb0b-3b92290b9637', variable: 'secret')])   
}
    }
    stage('retrieving code from git') {
        git 'https://github.com/Salimpossible/Projet_final.git'
    }
    stage('Creating the test environment via a terraform container') {
        sh ''' 
        cd ${terra_file_test}
        withCredentials
        docker run -it -v $(pwd):/workspace -w /workspace hashicorp/terraform:light apply -var-file=$secret -var-file="variables/main.tfvars"
        '''
    }

    // stage('Creating the test environment') {
    //     sh '''
    //     cd ${terra_file_test} 
    //     terraform init 
    //     terraform apply -var-file=${secrets}
    //     '''
    // }
//     stage('Provisionning of the Mongo-DB client') {
//         sh docker run -it -v $(pwd):/workspace -w /workpace ansible/ansible:centos7  ansible-playbook 
//     }
// }

