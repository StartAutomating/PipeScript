<#
.SYNOPSIS
    'new' keyword
.DESCRIPTION
    This transpiler enables the use of the keyword 'new'.

    new acts as it does in many other languages.  
    
    It creates an instance of an object.

    'new' can be followed by a typename and any number of arguments or hashtables.

    If 'new' is followed by a single string, and the type has a ::Parse method, new will parse the value.
.EXAMPLE
    .> { new DateTime }
.EXAMPLE
    .> { new byte 1 }
.EXAMPLE
    .> { new int[] 5 }
.EXAMPLE
    .> { new Timespan }
.EXAMPLE
    .> { new datetime 12/31/1999 }
.EXAMPLE
    .> { new @{RandomNumber = Get-Random; A ='b'}}
.EXAMPLE
    .> { new Diagnostics.ProcessStartInfo @{FileName='f'} }
.EXAMPLE
    .> { new ScriptBlock 'Get-Command'}
.EXAMPLE
    .> { (new PowerShell).AddScript("Get-Command").Invoke() }
.EXAMPLE
    .> { new 'https://schema.org/Thing' }
#>
[ValidateScript({
    $CommandAst = $_
    if ($CommandAst -isnot [Management.Automation.Language.CommandAst]) { return $false }
    return ($commandAst -and $CommandAst.CommandElements[0].Value -eq 'new')
})]
[Reflection.AssemblyMetadata("PipeScript.Keyword",$true)]
param(
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.CommandAst]
$CommandAst
)

process {
    $null, $newTypeName, $newArgs = $CommandAst.CommandElements
    $maybeGeneric = $false
    $propertiesToCreate   = @()
    $newTypeNameAst =  $newTypeName
    $newTypeName = 
        # Non-generic types will be a bareword constant        
        if ($newTypeName.Value) {
            $newTypeName.Value
        } 
        elseif ($newTypeName -is [Management.Automation.Language.HashtableAst]) {
            $propertiesToCreate += $newTypeName.Transpile()
        }        
        else {
            # generic types will be an ArrayLiteralAst
            $maybeGeneric = $true
            $newTypeName.Extent.ToString()
        }
    if ($newTypeName -match '^\[' -and $newTypeName -match '\]$' ) {
        $newTypeName = $newTypeName -replace '^\[' -replace '\]$'
    }
    

    
    $constructorArguments = @(
        foreach ($newArg in $newArgs) {
            # If the argument is a hashtable, treat it as properties to set after creation.
            if ($newArg -is [Management.Automation.Language.HashtableAst]) {
                $propertiesToCreate += $newArg.Transpile()
            } else {
            # Otherwise, treat it as arguments.
                $newArg
            }
        }
    )

    $constructorArguments = @(
        foreach ($constructorArg in $constructorArguments) {
            if ($constructorArg.StringConstantType -eq 'BareWord') {
                if ($constructorArg.Value -match '^\[[^\]]+\]') {
                    $constructorArg.Value
                } else {
                    "'" + $constructorArg.Value.Replace("'","''") + "'"
                }
            } else {
                $constructorArg.Transpile()
            }
        }
    )

    $realNewType = $newTypeName -as [type]
    if (-not $realNewType -and $maybeGeneric) {
        $realNewType = "Collections.Generic.$newTypeName" -as [type]
        if ($realNewType) {
            $newTypeName = "Collections.Generic.$newTypeName"
        }
    }

    $newNew = 
        if ($realNewType) {
            if ($realNewType::parse -and 
                $constructorArguments.Length -eq 1 -and 
                $constructorArguments[0] -is [string]) {
                "[$newTypeName]::parse(" + ($constructorArguments -join ',') + ")"
            } elseif ($realNewType::new) {
                if ($constructorArguments) {
                    "[$newTypeName]::new(" + ($constructorArguments -join ',') + ")"
                } elseif (-not ($realNewType::new.overloadDefinitions -match '\(\)$')) {
                    "[$newTypeName]::new(`$null)"
                } else {
                    "[$newTypeName]::new()"
                }
            } 
            elseif ($realNewType::create) {
                if ($constructorArguments) {
                    "[$newTypeName]::create(" + ($constructorArguments -join ',') + ")"
                }
                elseif (-not ($realNewType::create.overloadDefinitions -match '\(\)$')) {
                    "[$newTypeName]::create(`$null)"
                }
                else {
                    "[$newTypeName]::create()"
                }
            }            
            elseif ($realNewType.IsPrimitive) {
                if ($constructorArguments) {
                    if ($constructorArguments.Length -eq 1) {
                        "[$newTypeName]$constructorArguments"    
                    } else {
                        "[$newTypeName]($($constructorArguments -join ','))"
                    }                    
                } else {
                    "[$newTypeName]::new()"
                }
            }
        } elseif ($propertiesToCreate.Count -eq 1 -and -not $newTypeName) {
            "[PSCustomObject][Ordered]$propertiesToCreate"
        } elseif ($newTypeNameAst -is [Management.Automation.Language.StringConstantExpressionAst]) {
            if ($propertiesToCreate) {
                "[PSCustomObject]([Ordered]@{PSTypeName='$newTypeNameAst'} + $propertiesToCreate)"
            } else {
                "[PSCustomObject][Ordered]@{PSTypeName='$newTypeNameAst'}"
            }
        }
        else {
            Write-Error "Unknown type '$newTypeName'"                        
            return
        }

    if ($propertiesToCreate -and $newTypeName -and $realNewType) {
        $newNew = '$newObject = ' + $newNew + [Environment]::NewLine
        $newNew += (@(foreach ($propSet in $propertiesToCreate) {
            'foreach ($kvp in ' + "([Ordered]" + $propSet + ').GetEnumerator()) {
    $newObject.$($kvp.Key) = $kvp.Value
}'
        }) -join [Environment]::NewLine)
        $newNew += [Environment]::NewLine + '$newObject'
        $newNew = "`$($newNew)"
    }

    
    if ($newNew) {
        if ($CommandAst.IsPiped) {
            [scriptblock]::create(". { process {
$newNew
            } }")
        } else {
            [scriptblock]::Create($newNew)    
        }        
    } else {
        Write-Error "Unable to create '$newTypeName'"
        return
    }
}
