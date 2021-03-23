# eShopping Microservice Solution

This repository has solution with 2 microservices. Both microservices are created using REST API standard and uses JSON protocol as data exchange format.

These microservices have 3 features implemented

1. Controller that returns data for microservices (products, customers)
2. Version Middleware that returns version of microservice
3. PrintIP middleware that prints IP Address of microservice, to test the scaling

I use these microservices to test various deployment scenarios.

1. Deployment to VM using Deploy.ps1 scripts
2. Deployment to kubernetes using docker images

## 1. Deployment to VM using PowerShell scripts

These is 2 step process

### Step 1 - Build the Artifact

In order to build the artifact, I have created Publish.ps1 file that will build the microservices and create ZIP package which I then upload to my GIT repo. I use same repo for storing my Artifacts for sake of simplicity.

### Step 2 - Deploy the Artifact

Deploy.ps1 has needed powershell scripting to deploy the code artifact to VM. This powershell scripts needs to be run inside VM where we need to deploy code artifact. This script will download the code artifact ZIP file from GitHub repo and install on IIS inside VM.

powershell ./Deploy.ps1 customers "https://github.com/RonakThakkar/eShopping/raw/main/publish/eShopping.Customers.Service-1.0.0.zip"

powershell ./Deploy.ps1 customers "https://github.com/RonakThakkar/eShopping/raw/main/publish/eShopping.Customers.Service-2.0.0.zip"

## 2. Deployment to kubernetes using docker images

This is a 2 step process.

### Step 1 - Build the docker image

I have uploaded Docker images from these microservices to my dockerhub account by building them on local machine with version number incremented on every build.

I used following commands on local machine to build and push docker image.

docker build
docker tag
docker push

### Step 2 - Deploy the docker image

In order to deploy the microservices, I use kubectl. kubectl manifest files for different scenarios are located in separate repo.
