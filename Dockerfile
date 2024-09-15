# Thank you Microsoft!  Thank you PowerShell!  Thank you Docker!
FROM mcr.microsoft.com/powershell

# Store the module name in an environment variable (this should not change)
ENV ModuleName="PSDevOps"

# We set the shell to PowerShell,
SHELL ["/bin/pwsh", "-nologo", "-command"]

# run the initialization script
RUN --mount=type=bind,src=./,target=/Initialize ./Initialize/Container.init.ps1

# and set the entry point to `/Container.start.ps1`.
ENTRYPOINT ["pwsh", "-noexit", "-nologo", "-file", "/Container.start.ps1"]