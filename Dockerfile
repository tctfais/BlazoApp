FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5205

ENV ASPNETCORE_URLS=http://+:5205

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["BlazoApp.csproj", "./"]
RUN dotnet restore "BlazoApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "BlazoApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BlazoApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BlazoApp.dll"]
