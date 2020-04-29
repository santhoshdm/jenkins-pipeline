pipeline{
  agent any
  environment {
    PATH = "${PATH}:${getTerraformPath()}"
  }
//   tools {
//           terraform 'terraform12'
//       }
  stages{
    stage('S3Bucket'){
	  steps{
	    sh "cp /etc/ansible/ansible.cfg ."
		//sh "mv ansible.cfg-org ansible.cfg"
		sh "ansible-playbook s3bucket.yml"
		}
	}
// 	stage('TF-Backend'){
// 	  steps{
// 	    sh "terraform init"
// 		sh "ansible-playbook terraformbackend.yml"
// 		sh "terraform apply -auto-approve"
// 		sh "rm -rf ansible.cfg"
// 		}
// 	}
// 	stage ('BUILD-ENV') {
//             steps {
//                 sh '''
//                     echo "PATH = ${PATH}"
//                     echo "M2_HOME = ${M2_HOME}"
//                 '''
//             }
//         }
//     stage ('Build') {
//             steps {
//                 sh 'mvn -Dmaven.test.failure.ignore=true clean compile test package'
//             }
//         }
// 	stage ('AWS-Inventory') {
// 	  steps {
// 	    sh "chmod +x inventoryaws.sh"
// 		sh "./inventoryaws.sh"
//       }
//     }
//
// 	stage('APPServer-Config'){
// 	  steps{
// 	    sh "ansible-playbook -i dynainvent.aws tomcat-install.yml"
// 		}
// 	}
//
// 	stage('APP-Deploy'){
// 	  steps{
// 		sh "ansible-playbook -i dynainvent.aws deploy-app.yml"
// 		}
// 	}
//
// 	stage('SEC-TEST') {
//       steps {
//         probelyScan targetId: 'YmxppLPT5uwC', credentialsId: 'probely-security'
//       }
//     }
	
	stage('TF-Destroy'){
	  steps{
	    sh "terraform destroy -auto-approve"
		}
	}
  
 }
 
  post {
	  always {
	    slackSend baseUrl: 'https://hooks.slack.com/services/',
        channel: '#devops-cicd', color: 'good',
        message: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
        teamDomain: 'govanin.slack.com',
        tokenCredentialId: 'slack-token'
	    }
		
	  success {
	    sh label: '', returnStatus: true, script: 'wget --spider www.cloudlinuxacademy.com'
		}
    }
}  

def getTerraformPath(){
  def tfHome = tool name: 'terraform12', type: 'com.cloudbees.jenkins.plugins.customtools.CustomTool'
  return tfHome
  }