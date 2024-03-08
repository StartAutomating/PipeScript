[ValidatePattern('Bash')]
param()


function Template.Bash.Wrapper {

    <#
    .Synopsis
        Wraps PowerShell in a Bash Script
    .Description
        Wraps PowerShell in a Bash Script
    #>
    param(
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ScriptInfo')]
    [Management.Automation.ExternalScriptInfo]
    $ScriptInfo,

    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='ScriptBlock')]
    [ScriptBlock]
    $ScriptBlock
    )

    process {
        switch ($PSCmdlet.ParameterSetName) 
        {
            ScriptBlock {            
@"
#!/usr/bin/env bash
pwsh -noprofile -nologo -command "& {$($ScriptBlock -replace '"', '\"' -replace '\$', '\$')} $@ ; if (\`$error.Count) { exit 1}"
"@
            
            }
            ScriptInfo {
            @"
#!/usr/bin/env bash
pwsh -noprofile -nologo -command "& './$($ScriptInfo.Name)' $@ ; if (\`$error.Count) { exit 1}"
"@
                
            }
            
        }
    }

}

