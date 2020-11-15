# eShopping Microservice Solution

This repository has solution with 2 microservices (REST API) that can be used for testing kubernetes deployment.

Docker images from these solution are uploaded to  dockerhub by building on local machine with version number.

docker build
docker tag
docker push

# Instructions to use Deploy.ps1

powershell ./Deploy.ps1 customers "https://github.com/RonakThakkar/eShopping/raw/main/publish/eShopping.Customers.Service-1.0.0.zip"

powershell ./Deploy.ps1 customers "https://github.com/RonakThakkar/eShopping/raw/main/publish/eShopping.Customers.Service-2.0.0.zip"
