[ValidatePattern("(?>LUA|Language)[\s\p{P}]")]
param()


function Language.Lua {
<#
    .SYNOPSIS
        LUA PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate LUA.

        Multiline comments like ```--{[[```  ```--}]]``` will be treated as blocks of PipeScript.    
    #>
[ValidatePattern('\.lua$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    $FilePattern  = '\.lua$'

    # We start off by declaring a number of regular expressions:
    $startComment = '\-\-\[\[\{' # * Start Comments ```--[[{```
    $endComment   = '--\}\]\]'   # * End Comments   ```--}]]```
    $Whitespace   = '[\s\n\r]{0,}'        
    $StartPattern = "(?<PSStart>${startComment})"    
    $EndPattern   = "(?<PSEnd>${endComment}\s{0,})"

    # We might have to go looking for R's interpreter
    $interpreter = $(
        # (it may just be in the path)
        if ($ExecutionContext.SessionState.InvokeCommand.GetCommand('lua', 'Application')) {
            $ExecutionContext.SessionState.InvokeCommand.GetCommand('lua', 'Application')
        } elseif (
            # Or, if we're on Windows and there's a LUA %ProgramFiles(x86)% directory
            $IsWindows -and (Test-Path (Join-Path ${env:ProgramFiles(x86)} 'Lua'))
        ) {
            
            # We can look in there 
            $ExecutionContext.SessionState.InvokeCommand.GetCommand("$(
                Join-Path "${env:ProgramFiles(x86)}" 'Lua' | 
                Get-ChildItem -Directory | 
                # for the most recent version of R
                Sort-Object { $_.Name -as [Version]} -Descending  |  
                Select-Object  -First 1 |                 
                Join-Path -ChildPath "lua.exe"
            )", "Application")
        }
    )
    $LanguageName = 'Lua'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Lua")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


