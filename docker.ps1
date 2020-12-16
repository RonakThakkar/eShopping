param($version='1.0.0')
# echo (Get-Location).Path

# Publish eShopping.Customers.Service project as container image to dockerhub
$customersProject="eShopping.Customers.Service"
$tag="ronakthakkar/"+$customersProject.ToLower()+":"+$version
docker build -f $customersProject/Dockerfile -t $tag --build-arg version=$version .
docker push $tag

# Publish eShopping.ProductCatalog.Service as container image to dockerhub
$productServiceProject="eShopping.ProductCatalog.Service"
$tag="ronakthakkar/"+$productServiceProject.ToLower()+":"+$version
docker build -f $productServiceProject/Dockerfile -t $tag --build-arg version=$version .
docker push $tag