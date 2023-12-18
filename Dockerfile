
FROM mcr.microsoft.com/powershell


ENV PIPESCRIPT_VERSION 0.2.6


RUN apt-get update && apt-get install -y git curl ca-certificates libc6 libgcc1

ENV PSModulePath ./Modules


RUN opt/microsoft/powershell/7/pwsh --noprofile --nologo -c Install-Module 'Splatter','PSSVG','ugit','Irregular' -Scope CurrentUser -Force


COPY ./ ./Modules/PipeScript


COPY ././Http.Server.Start.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1


