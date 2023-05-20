<#
.SYNOPSIS
    requires one or more modules, variables, or types.    
.DESCRIPTION
    Requires will require on or more modules, variables, or types to exist.
.EXAMPLE
    requires latest pipescript  # will require the latest version of pipescript
.EXAMPLE
    requires variable $pid $sid # will error, because there is no $sid
#>

using namespace System.Management.Automation.Language

[ValidateScript({
    $validateVar = $_
    if ($validateVar -is [Management.Automation.Language.CommandAst]) {
        $cmdAst = $validateVar
        if ($cmdAst.CommandElements[0].Value -in 'require', 'requires') {
            return $true
        }
    }
    return $false
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
[Alias('Require')]
param(
# One or more required modules.
[Parameter(ValueFromPipelineByPropertyName)]
$Module,

# If set, will require the latest version of a module.
[Parameter(ValueFromPipelineByPropertyName)]
[switch]
$Latest,

# A ModuleLoader script can be used to dynamically load unresolved modules.
# This script will be passed the unloaded module as an argument, and should return a module.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('ModuleResolver', 'Module Loader', 'Module Resolver')]
[ScriptBlock]
$ModuleLoader,

# One or more required types.
[Parameter(ValueFromPipelineByPropertyName)]
$Type,

# A TypeLoader script can be used to dynamically load unresolved types.
# This script will be passed the unloaded type as an argument.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('TypeResolver', 'Type Loader', 'Type Resolver')]
[ScriptBlock]
$TypeLoader,

# One or more required variables.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('Variable')]
$Variables,

# A VariableLoader script can be used to dynamically load unresolved variable.
# This script will be passed the unloaded variable as an argument.
[Parameter(ValueFromPipelineByPropertyName)]
[Alias('VariableResolver', 'Variable Loader', 'Variable Resolver')]
[ScriptBlock]
$VariableLoader,

# The Command AST.  This will be provided when using the transpiler as a keyword.
[Parameter(Mandatory,ParameterSetName='CommandAST',ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst,

# The ScriptBlock.  This will be provided when using the transpiler as an attribute.
[Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipeline)]
[ScriptBlock]
$ScriptBlock = {}
)

process {
    # If we were called as a CommandAST
    if ($PSCmdlet.ParameterSetName -eq 'CommandAst') {
        # attempt to parse the command as a sentence.
        $mySentence = $commandAst.AsSentence($MyInvocation.MyCommand)           
    
        # If the sentence had parameters
        if ($mySentence.Parameter.Count) {            
            
            foreach ($clause in $mySentence.Clauses) {
                if ($clause.ParameterName) {
                    $ExecutionContext.SessionState.PSVariable.Set($clause.ParameterName, $mySentence.Parameter[$clause.Name])
                }
            }            
        }
        
        # If the sentence only any remaining arguments, treat them as modules
        if ($mySentence.Argument) {
            if ($Module) {
                $module = @($module) + $mySentence.Argument
            } else {
                $module = $mySentence.Argument
            }
        }        
    }

    #region Module Requirements
    $moduleRequirementScript = {}
    if ($Module) {
        $moduleRequirementsList = @(foreach ($mod in $module) {
            if ($mod -is [string]) {
                "'$($mod -replace "'","''")'"
            } else {
                "$mod"
            }
        }) -join ','
        $moduleRequirementScript = [ScriptBlock]::Create(
("`$ImportedRequirements = foreach (`$moduleRequirement in $moduleRequirementsList) {
    `$requireLatest = $(if ($Latest) { '$true' } else { '$false' })
    `$ModuleLoader  = $(if ($moduleLoader) { "{
        $moduleLoader
    }" } else { '$null'})
" + {
    # If the module requirement was a string
    if ($moduleRequirement -is [string]) {
        # see if it's already loaded
        $foundModuleRequirement = Get-Module $moduleRequirement
        if (-not $foundModuleRequirement) {
            # If it wasn't,
            $foundModuleRequirement = try { # try loading it
                Import-Module -Name $moduleRequirement -PassThru -Global -ErrorAction 'Ignore'
            } catch {                
                $null
            }
        }

        # If we found a version but require the latest version,
        if ($foundModuleRequirement -and $requireLatest) {
            # then find if there is a more recent version.
            Write-Verbose "Searching for a more recent version of $($foundModuleRequirement.Name)@$($foundModuleRequirement.Version)"

            if (-not $script:FoundModuleVersions) {
                $script:FoundModuleVersions = @{}
            }

            if (-not $script:FoundModuleVersions[$foundModuleRequirement.Name]) {
                $script:FoundModuleVersions[$foundModuleRequirement.Name] = Find-Module -Name $foundModuleRequirement.Name            
            }
            $foundModuleInGallery = $script:FoundModuleVersions[$foundModuleRequirement.Name]
            if ($foundModuleInGallery -and 
                ([Version]$foundModuleInGallery.Version -gt [Version]$foundModuleRequirement.Version)) {
                Write-Verbose "$($foundModuleInGallery.Name)@$($foundModuleInGallery.Version)"
                # If there was a more recent version, unload the one we already have
                $foundModuleRequirement | Remove-Module # Unload the existing module
                $foundModuleRequirement = $null
            } else {
                Write-Verbose "$($foundModuleRequirement.Name)@$($foundModuleRequirement.Version) is the latest"
            }
        }

        # If we have no found the required module at this point
        if (-not $foundModuleRequirement) {
            if ($moduleLoader) { # load it using a -ModuleLoader (if provided)
                $foundModuleRequirement = . $moduleLoader $moduleRequirement
            } else {
                # or install it from the gallery.
                Install-Module -Name $moduleRequirement -Scope CurrentUser -Force -AllowClobber
                if ($?) {
                    # Provided the installation worked, try importing it
                    $foundModuleRequirement =
                        Import-Module -Name $moduleRequirement -PassThru -Global -ErrorAction 'Continue' -Force
                }
            }
        } else {
            $foundModuleRequirement
        }
    }
} + "}")
        )
    }
    #endregion Module Requirements

    #region Variable Requirements
    $variableRequirementScript = {}
    if ($Variables) {
        # Translate variables into their string names.
        $variableRequirementsList = @(foreach ($var in $Variables) {
            if ($var -is [string]) {
                "'$($var -replace "'","''")'"
            }
            elseif ($var -is [VariableExpressionAst]) {
                "'$($var.variablepath.ToString() -replace "'", "''")'"
            }            
        }) -join ','
        $variableRequirementScript = 
"foreach (`$variableRequirement in $variableRequirementsList) {
    `$variableLoader = $(if ($VariableLoader) { "{
        $variableLoader    
    }"} else { '$null'})
" + {
    if (-not $ExecutionContext.SessionState.PSVariable.Get($variableRequirement)) {
        if ($VariableLoader) {
            . $VariableLoader $variableRequirement
            if (-not $ExecutionContext.SessionState.PSVariable.Get($variableRequirement)) {

            }
        } else {
            Write-Error "Missing required variable $variableRequirement"        
        }
    }
} +
"}"
        $variableRequirementScript = [scriptblock]::Create($variableRequirementScript)
    }
    #endregion Variable Requirements

    #region Type Requirements
    $typeRequirementScript = {}
    if ($type) {
        $typeRequirementsList = @(foreach ($typeName in $Type) {
            if ($typeName -is [string]) {
                "'$($typeName -replace "^\[" -replace '\]$')'"
            } elseif ($typeName.TypeName) {
                "'$($typeName.TypeName.ToString())'"
            }
        }) -join ','
        $typeRequirementScript = 
"foreach (`$typeRequirement in $typeRequirementsList) {
    `$typeLoader = $(if ($TypeLoader) { 
        "{$typeLoader}"
    } else { '$null'})
    " + {
    if (-not ($typeRequirement -as [type])) {
        if ($TypeLoader) {
            . $TypeLoader $typeName
            if (-not ($typeRequirement -as [type])) {            
                Write-Error "Type [$typeRequirement] could not be loaded"  
            }
        } else {
            Write-Error "Type [$typeRequirement] is not loaded"
        }        
    }
} + "}"
        $typeRequirementScript = [scriptblock]::Create($typeRequirementScript)
    }
    #endregion Type Requirements

    if ($PSCmdlet.ParameterSetName -eq 'CommandAst') {
        $moduleRequirementScript, $variableRequirementScript, $typeRequirementScript | Join-PipeScript
    } else {
        $declareInBlock = 'begin'
        if ($scriptBlock.Ast.dynamicParam) {
            $declareInBlock = 'dynamicParam'
        }
        
        $moduleRequirementScript   = [ScriptBlock]::Create("$declareInBlock {
    $ModuleRequirementScript
}")
        $variableRequirementScript = [ScriptBlock]::Create("$declareInBlock {
    $variableRequirementScript
}")
        $typeRequirementScript     = [ScriptBlock]::Create("$declareInBlock {
    $typeRequirementScript
}")
        $ScriptBlock, $moduleRequirementScript, $variableRequirementScript, $typeRequirementScript | Join-PipeScript
    }        
}