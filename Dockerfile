FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["pipelines-dotnet-core.csproj", "./"]
RUN dotnet restore "./pipelines-dotnet-core.csproj"
COPY . .
RUN dotnet build "pipelines-dotnet-core.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "pipelines-dotnet-core.csproj" -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 5001

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core.dl"]
