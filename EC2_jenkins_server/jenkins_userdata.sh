#!/bin/bash
set -e

# Update system
apt-get update -y

# Install Java (Jenkins requirement)
apt-get install -y openjdk-17-jdk

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

# Start & enable Jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Git
apt-get install -y git

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg \
  | gpg --dearmor \
  | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main \
  | tee /etc/apt/sources.list.d/hashicorp.list

apt-get update -y
apt-get install -y terraform

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl
