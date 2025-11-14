### *RefineOps – CI/CD Pipeline with Jenkins, Docker, Kubernetes (k3s), Prometheus & Grafana*

---

# 🚀 RefineOps – Automated CI/CD Pipeline on AWS

RefineOps is a fully automated, cloud-native CI/CD pipeline implemented using **AWS EC2, Jenkins, Docker, DockerHub, Kubernetes (k3s), Prometheus, and Grafana**.
This project demonstrates real-world DevOps practices including continuous integration, continuous deployment, containerization, orchestration, and monitoring.

---

# 📌 **Project Overview**

The goal of RefineOps is to automate application delivery through:

* Automated CI/CD with Jenkins
* GitHub Webhook triggered builds
* Docker image creation and vulnerability scanning
* Image push to DockerHub
* Kubernetes deployment via k3s
* Real-time monitoring with Prometheus & Grafana

This project was developed as part of an internship to demonstrate **end-to-end DevOps implementation on cloud infrastructure**.

---

# 🏗 **Architecture Diagram**

```
GitHub → Jenkins (EC2) → Docker Build → Trivy Scan → DockerHub
                  ↓
             Kubernetes (k3s)
                  ↓
           Prometheus → Grafana
```

---

# 🧩 **Key Features**

* 🔄 Automated CI/CD Pipeline
* 🐳 Docker-based Application Deployment
* 🔐 Trivy Image Security Scanning
* ☸️ Kubernetes (k3s) Orchestration
* 📡 GitHub Webhook Integration
* 📊 Prometheus & Grafana Monitoring
* 🔁 Rolling Updates on Kubernetes

---

# 🛠 **Tools & Technologies Used**

| Category         | Tools               |
| ---------------- | ------------------- |
| Cloud            | AWS EC2             |
| CI/CD            | Jenkins             |
| Version Control  | GitHub              |
| Containerization | Docker              |
| Image Registry   | DockerHub           |
| Orchestration    | Kubernetes (k3s)    |
| Monitoring       | Prometheus, Grafana |
| Security         | Trivy               |

---

# 📦 **Project Structure**

```
RefineOps/
│── Jenkinsfile
│── Dockerfile
│── sonar-project.properties
│── k8s/
│     ├── deployment.yaml
│     └── service.yaml
│── monitoring/
│     ├── prometheus.yml
│     └── datasources/
│── scripts/
│     └── deploy.sh
│── README.md
```

---

# 🔄 **CI/CD Pipeline Flow**

1. **Code Push to GitHub**
2. **GitHub Webhook triggers Jenkins**
3. Jenkins Pipeline Stages:

   * Checkout source code
   * Build Docker image
   * Run Trivy security scan
   * Push image to DockerHub
   * Deploy to Kubernetes
   * Notify via email/Slack (optional)
4. Kubernetes pulls latest image
5. Application becomes live
6. Prometheus collects metrics
7. Grafana displays dashboards

---

# ⚙️ **Jenkins Pipeline Summary**

### **1. Checkout Stage**

Pulls latest code from GitHub main branch.

### **2. Build Stage**

Builds the Docker image using Dockerfile.

### **3. Scan Stage**

Runs Trivy vulnerability scan on the Docker image.

### **4. Push Stage**

Pushes secure image to DockerHub registry.

### **5. Deploy Stage**

Applies Kubernetes manifests using:

```
kubectl apply -f k8s/
```

### **6. Completion Stage**

Sends result notifications.

---

# ☸️ **Kubernetes Deployment Overview**

### ✔ Deployment (deployment.yaml)

Defines replica sets, containers, and rolling updates.

### ✔ Service (service.yaml)

Exposes app externally using NodePort `30080`.

### ✔ Commands to Verify

```
kubectl get pods
kubectl get svc
kubectl describe pod <pod-name>
```

### ✔ Access Application

```
http://<EC2-Public-IP>:30080
```

---

# 📊 **Monitoring Setup**

### ✔ Prometheus

* Scrapes node & pod metrics
* Runs on port **9090**

### ✔ Grafana

* Visualization tool
* Runs on port **3000**
* Datasource: **Prometheus**
* Dashboards include:

  * Node Exporter Full
  * Cluster Metrics
  * Pod/Container Performance

---

# 📅 **Development Timeline (06 October – 16 November)**

| Week   | Work Summary                                                |
| ------ | ----------------------------------------------------------- |
| Week 1 | AWS setup, EC2 configuration, dependency installation       |
| Week 2 | Jenkins installation, webhook setup                         |
| Week 3 | Dockerization, Trivy scan, DockerHub integration            |
| Week 4 | Kubernetes (k3s) installation, first deployment             |
| Week 5 | Full pipeline automation to Kubernetes                      |
| Week 6 | Monitoring setup with Prometheus and Grafana, documentation |

---

# 📘 **How to Run the Project**

### **1. Clone the Repository**

```bash
git clone https://github.com/tanvirmulla11/RefineOps.git
cd RefineOps
```

### **2. Build Docker Image**

```bash
docker build -t <your-image-name> .
```

### **3. Apply Kubernetes Manifests**

```bash
kubectl apply -f k8s/
```

### **4. Access Application**

```bash
http://<EC2-Public-IP>:30080
```

---

# 🎯 **Results**

* CI/CD pipeline successfully automated
* Application deployed on Kubernetes via Jenkins
* Monitoring dashboards fully functional
* Vulnerability-free Docker images
* Cloud-hosted end-to-end deployment

---

# 🙌 **Acknowledgments**

Special thanks to mentors and the internship program for guidance and support throughout this project.

---

# 📄 **License**

This project is intended strictly for educational & internship demonstration purposes.

---
