FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# See https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/building-net-docker-images?view=aspnetcore-3.1

# copy csproj and restore as distinct layers
COPY *.sln .
COPY dlcs-user-documentation/*.csproj ./dlcs-user-documentation/
RUN dotnet restore

# copy everything else and build app
COPY dlcs-user-documentation/. ./dlcs-user-documentation/
WORKDIR /app/dlcs-user-documentation
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/dlcs-user-documentation/out ./
ENTRYPOINT ["dotnet", "dlcs-user-documentation.dll"]
