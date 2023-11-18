#requires -Module EZOut
#  Install-Module EZOut or https://github.com/StartAutomating/EZOut
param()

$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = 'PipeScript'
$myRoot = $myFile | Split-Path | Split-Path
Push-Location $myRoot
$formatting = @(
    # Add your own Write-FormatView here,
    # or put them in a Formatting or Views directory
    foreach ($potentialDirectory in 'Formatting','Views','Types') {
        Join-Path $myRoot $potentialDirectory |
            Get-ChildItem -ea ignore |
            Import-FormatView -FilePath {$_.Fullname}
    }
)

$destinationRoot = $myRoot

if ($formatting) {
    $myFormatFile = Join-Path $destinationRoot "$myModuleName.format.ps1xml"
    
    $formatting | Out-FormatData -Module $MyModuleName -OutputPath $MyFormatFile
    $formatting | Out-FormatData -Module $MyModuleName -OutputPath ([Ordered]@{
        "System.Management.Automation.*" = "$(Join-Path $destinationRoot "PipeScript.Extends.PowerShell.format.ps1xml")"
        "Microsoft.CodeAnalysis.*" = "$(Join-Path $destinationRoot "PipeScript.Extends.CodeAnalysis.format.ps1xml")"        
        "PipeScript.Net.*" = "$(Join-Path $destinationRoot "PipeScript.Net.format.ps1xml")"
    })
}

$types = @(
    # Add your own Write-TypeView statements here
    # or declare them in the 'Types' directory
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
        Import-TypeView

)

if ($types) {
    $myTypesFile = Join-Path $destinationRoot "$myModuleName.types.ps1xml"

    $types | Out-TypeData -OutputPath $myTypesFile 
    $types | Out-TypeData -OutputPath ([Ordered]@{
        "System.Management.Automation.*" = "$(Join-Path $destinationRoot "PipeScript.Extends.PowerShell.types.ps1xml")"
        "Microsoft.CodeAnalysis.*" = "$(Join-Path $destinationRoot "PipeScript.Extends.CodeAnalysis.types.ps1xml")"
        "PipeScript.Net.*" = "$(Join-Path $destinationRoot "PipeScript.Net.types.ps1xml")"
    })#>    
}
Pop-Location
