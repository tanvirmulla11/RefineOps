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
        git branch: 'main', url: 'https://github.com/tanvirmulla11/RefineOps.git'
      }
    }

    stage('Terraform Apply - Create EC2') {
      steps {
        dir('terraform') {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY', passwordVariable: 'AWS_SECRET_KEY')]) {
            sh '''
              echo "Configuring AWS credentials..."
              mkdir -p ~/.aws
              cat > ~/.aws/credentials <<EOF
[default]
aws_access_key_id=$AWS_ACCESS_KEY
aws_secret_access_key=$AWS_SECRET_KEY
EOF

              cat > ~/.aws/config <<EOF
[default]
region=us-east-1
EOF

              terraform init -input=false
              terraform plan -input=false -var "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" -var "AWS_SECRET_KEY=$AWS_SECRET_KEY"
              terraform apply -input=false -auto-approve -var "AWS_ACCESS_KEY=$AWS_ACCESS_KEY" -var "AWS_SECRET_KEY=$AWS_SECRET_KEY"
            '''
          }
        }
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh '''
            echo "Running SonarQube analysis..."
            sonar-scanner \
              -Dsonar.projectKey=RefineOps \
              -Dsonar.projectName=RefineOps \
              -Dsonar.projectVersion=1.0 \
              -Dsonar.sources=. \
              -Dsonar.language=java \
              -Dsonar.sourceEncoding=UTF-8
          '''
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
          sh '''
            echo $PASS | docker login -u $USER --password-stdin
            docker push $DOCKER_IMAGE:latest
          '''
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
      emailext to: 'tanvirmulla73@gmail.com',
               subject: '✅ RefineOps Build Success',
               body: 'RefineOps app deployed successfully!'
    }
    failure {
      emailext to: 'tanvirmulla73@gmail.com',
               subject: '❌ RefineOps Build Failed',
               body: 'Please check Jenkins logs.'
    }
  }
}
