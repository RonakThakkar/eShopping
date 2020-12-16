#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["eShopping.ProductCatalog.Service/eShopping.ProductCatalog.Service.csproj", "eShopping.ProductCatalog.Service/"]
RUN dotnet restore "eShopping.ProductCatalog.Service/eShopping.ProductCatalog.Service.csproj"
COPY . .
WORKDIR "/src/eShopping.ProductCatalog.Service"
RUN dotnet build "eShopping.ProductCatalog.Service.csproj" -c Release -o /app/build

FROM build AS publish
ARG version
RUN dotnet publish "eShopping.ProductCatalog.Service.csproj" -c Release /property:Version=$version -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eShopping.ProductCatalog.Service.dll"]