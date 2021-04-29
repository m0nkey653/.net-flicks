FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app
COPY ./DotNetFlicks ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2
WORKDIR /app
COPY --from=build-env /app/DotNetFlicks.Web/out .
COPY --from=build-env /app/DotNetFlicks.Web/Config/SeedData/*.* ./Config/SeedData/
COPY --chmod=+x ./entrypoint.sh .
CMD /bin/bash entrypoint.sh
# ENTRYPOINT ["dotnet", "DotNetFlicks.Web.dll"]