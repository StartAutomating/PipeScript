    FROM mcr.microsoft.com/powershell


    COPY ./ ./Modules/PipeScript
ENV PSModulePath ./Modules

    
