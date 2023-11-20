FROM mcr.microsoft.com/powershell


ENV PIPESCRIPT_VERSION 0.2.6


COPY ./ ./Modules/PipeScript


COPY ././PipeScript.Server.Start.ps1 /root/.config/powershell/Microsoft.PowerShell_profile.ps1
ENV PSModulePath ./Modules






