
function Template.HTML.Parameter.Input {

    <#
    .SYNOPSIS
        Generates an HTML parameter input.
    .DESCRIPTION
        Generates an HTML input element for a parameter.
    #>
    [CmdletBinding(DefaultParameterSetName='None')]
    param(
    # The Parameter Metadata.  This can be provided via the pipeline from the Parameter.Values of any command.
    [Parameter(Mandatory,ParameterSetName='ParameterMetadata',ValueFromPipeline)]
    [Management.Automation.ParameterMetaData]
    $ParameterMetadata,

    # The name of the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $CommandName,

    # The name of the parameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParameterName,
    
    # The parameter attributes
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attribute','Attributes')]
    [PSObject[]]
    $ParameterAttribute,

    # The parameter type
    [Parameter(ValueFromPipelineByPropertyName)]
    [type]
    $ParameterType,

    # The parameter help.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ParameterHelp,

    # If set, the automatic parameters will be included.
    # (by default, they will be hidden)
    [Parameter(ValueFromPipelineByPropertyName)]
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
            {$_ -is [ValidateRange]}
            {
                                $htmlInputParameters.min = $attribute.Minimum
                                $htmlInputParameters.max = $attribute.Maximum
                            }
            {$_ -is [ValidatePattern]}
            {
                                $htmlInputParameters.pattern = $attribute.RegexPattern
                            }
            {$_ -is [ValidateSet]}
            {
                                $validValuesList += $attribute.ValidValues
                            }
            {$_ -is [Reflection.AssemblyMetadataAttribute]}
            {
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


