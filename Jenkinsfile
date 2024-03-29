pipeline {
  agent any
  stages{

    stage('setting YC variables default.tf'){
        steps{
            sh 'sed -i "s/{token}/$(/var/lib/jenkins/yandex-cloud/bin/yc config get token)/g" default.tf'
            sh 'sed -i "s/{cloud_id}/$(/var/lib/jenkins/yandex-cloud/bin/yc config get cloud-id)/g" default.tf'
            sh 'sed -i "s/{folder_id}/$(/var/lib/jenkins/yandex-cloud/bin/yc config get folder-id)/g" default.tf'
        }
    }

    stage('Gen id_rsa'){
        steps{
            sh """ssh-keygen -y -t rsa -N \\"\\" -f /var/lib/jenkins/.ssh/id_rsa_box """
            sh 'sed -i "s|id_rsa|$(cat /var/lib/jenkins/.ssh/id_rsa_box.pub)|g" meta.txt'
        }
    }


    stage('Terraform init') {
        steps {
            echo "terraform init" 
            sh 'terraform init'
        }
    }
    stage('Terraform apply') {
        steps {
            echo "terraform apply" 
            sh 'terraform apply --auto-approve'
            }
    }


    stage('Filling in the file host for ansible'){
        steps {
            echo "Filling in the file host for ansible" 
            sh """
            echo '[build]' > ./hosts
            terraform output -raw nat_ip_vm_build >> ./hosts
            echo ' ansible_user=jenkins ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa_box' >> ./hosts
            
            echo '\n[prod]' >> ./hosts
            terraform output -raw  nat_ip_vm_prod >> ./hosts
            echo ' ansible_user=jenkins ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/id_rsa_box' >> ./hosts
            
            echo '\n' >> ./hosts
            """
        }
    }

    stage('add instans ip to known_hosts'){
        steps{
            echo "add instans ip to known_hosts" 
            sh 'ssh-keyscan -H  "$(terraform output -raw nat_ip_vm_build)" > ~/.ssh/known_hosts'
            sh 'ssh-keyscan -H  "$(terraform output -raw nat_ip_vm_prod)" >> ~/.ssh/known_hosts'
        }
    }

    stage('ansible'){
        steps{
            sh 'ansible-playbook build_push_run_Docker.yml'
        }
    } 
    stage('delete build instans'){
        steps{
            timeout(time: 180, unit: 'SECONDS') {
                sh '/var/lib/jenkins/yandex-cloud/bin/yc compute instance delete "$(terraform output -raw vm_build_id)"'
            }
        }
    }
    stage('link to site'){
        steps{
                script {
                    def output = sh(script: "terraform output -raw nat_ip_vm_prod", returnStdout: true)
                    echo "Ссылка на сайт http://${output}:8080/hello-1.0"
                }
            }
    }

  }
}
