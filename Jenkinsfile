pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "tanvirmulla11/refineops-app"
    SONARQUBE = "SonarQube"
    KUBECONFIG = "/home/ubuntu/.kube/config"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git 'https://github.com/tanvirmulla11/refineops.git'
      }
    }

    stage('Terraform Apply - Create EC2') {
      steps {
        dir('terraform') {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']]) {
            sh '''
              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'sonar-scanner'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $DOCKER_IMAGE:latest .'
      }
    }

    stage('Security Scan (Trivy)') {
      steps {
        sh 'trivy image $DOCKER_IMAGE:latest || true'
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh 'docker push $DOCKER_IMAGE:latest'
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh 'kubectl --kubeconfig=$KUBECONFIG apply -f k8s/'
      }
    }
  }

  post {
    success {
      emailext to: 'tanvirmulla73@gmail.com', subject: '✅ RefineOps Build Success', body: 'RefineOps app deployed successfully!'
    }
    failure {
      emailext to: 'tanvirmulla73@gmail.com', subject: '❌ RefineOps Build Failed', body: 'Please check Jenkins logs.'
    }
  }
}
