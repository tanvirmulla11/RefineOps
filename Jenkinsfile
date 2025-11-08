pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "tanvirmulla11/refineops-app"
    KUBECONFIG = "/home/ubuntu/.kube/config"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/tanvirmulla11/RefineOps.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          echo "🐳 Building Docker image..."
          docker build -t $DOCKER_IMAGE:latest .
        '''
      }
    }

    stage('Security Scan (Trivy)') {
      steps {
        sh '''
          echo "🛡️ Scanning Docker image for vulnerabilities..."
          trivy image $DOCKER_IMAGE:latest || true
        '''
      }
    }

    stage('Push Docker Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
            echo "📦 Pushing image to DockerHub..."
            echo $PASS | docker login -u $USER --password-stdin
            docker push $DOCKER_IMAGE:latest
          '''
        }
      }
    }

    stage('Deploy to Kubernetes (K3s EC2 #2)') {
      steps {
        sh '''
          echo "🚀 Deploying to Kubernetes Cluster..."
          kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment.yaml
          kubectl --kubeconfig=$KUBECONFIG apply -f k8s/service.yaml
          echo "⏳ Waiting for deployment rollout..."
          kubectl --kubeconfig=$KUBECONFIG rollout status deployment/refineops-app
          echo "✅ Deployment completed successfully!"
        '''
      }
    }
  }

  post {
    success {
      emailext to: 'tanvirmulla73@gmail.com',
               subject: '✅ RefineOps Build Success',
               body: 'RefineOps app deployed successfully to your K3s cluster!'
    }
    failure {
      emailext to: 'tanvirmulla73@gmail.com',
               subject: '❌ RefineOps Build Failed',
               body: 'Please check Jenkins console output for errors.'
    }
  }
}
