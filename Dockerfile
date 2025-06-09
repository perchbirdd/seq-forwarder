FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["src/Seq.Forwarder/Seq.Forwarder.csproj", "./src/Seq.Forwarder/Seq.Forwarder.csproj"]
RUN dotnet restore src/Seq.Forwarder/Seq.Forwarder.csproj

COPY . .

RUN dotnet publish -c Release -o /app/publish src/Seq.Forwarder/Seq.Forwarder.csproj

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

RUN apt-get update && \
    apt-get install -y liblmdb-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app/publish .

EXPOSE 15341

ENTRYPOINT ["dotnet", "seqfwd.dll", "run"]