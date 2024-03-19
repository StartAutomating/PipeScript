Template function HTML.Parameter.Input {
    <#
    .SYNOPSIS
        Generates an HTML parameter input.
    .DESCRIPTION
        Generates an HTML input element for a parameter.
    #>
    [CmdletBinding(DefaultParameterSetName='None')]
    param(
    # The Parameter Metadata.  This can be provided via the pipeline from the Parameter.Values of any command.
    [vfp(Mandatory,ParameterSetName='ParameterMetadata')]
    [Management.Automation.ParameterMetaData]
    $ParameterMetadata,

    # The name of the command.
    [vbn()]
    [string]
    $CommandName,

    # The name of the parameter.
    [vbn()]
    [string]
    $ParameterName,
    
    # The parameter attributes
    [vbn()]
    [Alias('Attribute','Attributes')]
    [PSObject[]]
    $ParameterAttribute,

    # The parameter type
    [vbn()]
    [type]
    $ParameterType,

    # The parameter help.
    [vbn()]
    [string]
    $ParameterHelp,

    # If set, the automatic parameters will be included.
    # (by default, they will be hidden)
    [vbn()]
    [Alias('IncludeAutomaticParameters')]
    [switch]
    $IncludeAutomaticParameter
    )

    process {
        
        if ($PSCmdlet.ParameterSetName -eq 'ParameterMetadata') {
            $ParameterName = $ParameterMetadata.Name
            $ParameterType = $ParameterMetadata.ParameterType
            $Alias = $ParameterMetadata.Aliases
            $ParameterAttribute = $ParameterMetadata.Attributes
        }
        
        if (-not $IncludeAutomaticParameter) {
            if ($ParameterName -in 'Verbose','Debug',
                'ErrorAction','ErrorVariable',
                'WarningAction','WarningVariable',
                'InformationAction','InformationVariable',
                'ProgressAction',
                'Confirm','WhatIf',
                'OutBuffer','OutVariable',
                'PipelineVariable'
            ) {
                return
            }
        }

        $htmlInputParameters = [Ordered]@{
            Name = $ParameterName
        }

        if ($CommandName) {
            $htmlInputParameters.id = "$CommandName-$ParameterName" -replace '\p{P}', '-' -replace "\s", '_'
        } else {
            $htmlInputParameters.id = $ParameterName -replace '\p{P}', '-' -replace "\s", '_'
        }

        $validValuesList = @()

        :PickingInputType switch ($ParameterType) {
            { $_ -in [int], [double] } {
                $htmlInputParameters.type = 'number'
                break
            }
            { $_ -eq [DateTime]} {
                $htmlInputParameters.type = 'datetime-local'
                break
            }
            { $_ -eq [bool] -or $_ -eq [switch]} {
                $htmlInputParameters.type = 'checkbox'
                break
            }
            { $_.IsSubclassOf([Enum]) } {
                $validValuesList += [Enum]::GetNames($ParameterType)                
            }
            { $_ -eq [IO.FileInfo]} {
                $htmlInputParameters.type = 'file'
                break
            }
            default {
                switch -regex ($ParameterName) {
                    'Colou?r' {
                        $htmlInputParameters.type = 'color'
                        break PickingInputType
                    }
                    'Email' {
                        $htmlInputParameters.type = 'email'
                        break PickingInputType
                    
                    }
                }
                $htmlInputParameters.type = 'text'
            }
        }



        
        foreach ($attribute in $ParameterAttribute) {
            switch ($attribute) {
                [ValidateRange] {
                    $htmlInputParameters.min = $attribute.Minimum
                    $htmlInputParameters.max = $attribute.Maximum
                }
                [ValidatePattern] {
                    $htmlInputParameters.pattern = $attribute.RegexPattern
                }
                [ValidateSet] {
                    $validValuesList += $attribute.ValidValues
                }
                [Reflection.AssemblyMetadataAttribute] {
                    if ($attribute.Key -match 'Html\.?InputType') {
                        $htmlInputParameters.type = $attribute.Value
                    }
                    elseif ($attribute.Key -eq 'HTML.Input' -or 'Input.HTML') {
                        return $attribute.Value
                    }
                }
            }                        
        }

        
        if ($validValuesList) {
            "<select name='$parameterName'>"
            foreach ($validValue in $validValuesList) {
                "<option value='$([Web.HttpUtility]::HtmlAttributeEncode($validValue))'>$([Web.HttpUtility]::HtmlEncode($validValue))</option>"
            }
            "</select>"
        } else {
            $htmlInputParameters.Label = $ParameterName
            Template.HTML.InputElement @htmlInputParameters
        }                
    }
}
