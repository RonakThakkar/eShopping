param($version='1.0.0')
# echo (Get-Location).Path

# Publish eShopping.Customers.Service project as ZIP package
$customersProject="eShopping.Customers.Service"
dotnet publish `
.\$customersProject\$customersProject.csproj `
--configuration Release `
/property:Version=$version `
--output .\publish\$customersProject

Compress-Archive -Path .\publish\$customersProject\* -DestinationPath .\publish\$customersProject-$version.zip -Force
Remove-Item .\publish\$customersProject -Recurse

# Publish eShopping.ProductCatalog.Service project as ZIP package
$productServiceProject="eShopping.ProductCatalog.Service"
dotnet publish `
.\$productServiceProject\$productServiceProject.csproj `
--configuration Release `
/property:Version=$version `
--output .\publish\$productServiceProject

Compress-Archive -Path .\publish\$productServiceProject\* -DestinationPath .\publish\$productServiceProject-$version.zip -Force
Remove-Item .\publish\$productServiceProject -Recurse