[ValidatePattern('HTML')]
param()


Template function HTML.Command.Input {
    <#
    .SYNOPSIS
        Generates an HTML command input.
    .DESCRIPTION
        Generates HTML input for a command.
    .EXAMPLE
        Get-Command Get-Command | Template.HTML.Command.Input
    .EXAMPLE
        Get-Command Template.HTML.Command.Input | Template.HTML.Command.Input
    #>
    [CmdletBinding(DefaultParameterSetName='None')]
    param(
    # The Command Metadata.  This can be provided via the pipeline from Get-Command.
    [vfp(Mandatory,ParameterSetName='ParameterMetadata')]
    [Management.Automation.CommandMetadata]
    $CommandMetadata,

    # The name of the command.
    [vbn()]
    [Alias('CommandName')]
    [string]
    $Name,

    # If the command supports ShouldProcess (`-WhatIf`, `-Confirm`)
    [vbn()]
    [switch]
    $SupportsShouldProcess,

    # If the command supports paging.
    [vbn()]
    [switch]
    $SupportsPaging,

    # If the command supports positional binding
    [vbn()]
    [switch]
    $PositionalBinding,

    # The help URI for the command.
    [vbn()]
    [uri]
    $HelpUri,

    # The confirm impact of the command.
    [vbn()]
    [Management.Automation.ConfirmImpact]
    $ConfirmImpact,

    # The parameter metadata for the command.
    [vbn()]
    [Alias('Parameters')]
    [PSObject]
    $Parameter,

    # The Command Description.
    [vbn()]
    [Alias('CommandDescription')]
    [string]
    $Description,

    # The Command Synopsis.
    [vbn()]
    [Alias('CommandSynopsis')]
    [string]
    $Synopsis,

    # The Command Example.
    [vbn()]
    [Alias('CommandExample')]
    [string[]]
    $Example,

    # The Command Notes.
    [vbn()]
    [Alias('Note','CommandNotes')]
    [string[]]
    $Notes,

    # The Command Links.
    [vbn()]
    [Alias('Links','CommandLinks')]
    [string[]]
    $Link,
    
    # The Element Map.
    # This maps parameters to the HTML elements that will be used to render them.    
    [vbn()]
    [Alias('ElementNameMap','ElementNames')]
    [PSObject]
    $ElementMap = [Ordered]@{
        'Name' = 'h2'
        'Synopsis' = 'p'
        'Description' = 'p'        
        'Example' = 'code'
        'Link' = 'p'
        'Notes' = 'p'        
    },

    # The Element Attribute Map.
    # This maps parameters to the HTML element attributes that will be used to render them.    
    [vbn()]
    [PSObject]
    $ElementAttributeMap = [Ordered]@{
        'Example' = [Ordered]@{
            'class' = 'language-powershell'
            'language' = 'PowerShell'
        }
    },

    # The element separator.  This is used to separate elements.
    [vbn()]
    [psobject]
    $ElementSeparator,
    
    # The Command Attributes.  These are used to provide additional information about the command.
    # They will be automatically provided if piping a command into this function.
    # If an attribute named HTML.Input is provided, it will be returned directly.
    [vbn()]
    [Alias('Attributes','CommandAttribute','CommandAttributes')]
    [PSObject[]]
    $Attribute,

    # The Container Element.  This is used to hold all of the elements.
    [vbn()]
    [string]
    $ContainerElement,

    # The Container Attributes.
    [vbn()]
    [PSObject[]]
    $ContainerAttribute,

    # The Item Element.  This is used to hold each item.
    [vbn()]
    [string]
    $ItemElement,

    # The Item Attributes.
    [vbn()]
    [PSObject[]]
    $ItemAttribute,

    # The Item Separator.  This is used to separate items.
    # The default is a line break.
    [vbn()]
    [PSObject]
    $ItemSeparator = "<br/>"
    )

    begin {

    }

    process {
        # First, check our attributes
        foreach ($attr in $Attribute) {
            # to see if we have an HTML Input attribute.
            if ($attr -is [Reflection.AssemblyMetadataAttribute] -and
                $attr.Key -match '^HTML\p{P}?Input') {
                # If we do, return it.
                return $attr.Value
            }
        }


        $myParameterCopy = [Ordered]@{} + $PSBoundParameters
        $elementOrder    = 
            @(if ($elementMap -is [Collections.IDictionary]) {
                $elementMap.Keys
            } else {
                $elementMap.PSObject.Properties.Name
            })



        $ItemsInContainer = @(
            foreach ($potentialElement in $elementOrder) {
                if ($myParameterCopy.($potentialElement)) {
                    $ElementSplat = [Ordered]@{
                        Name = $elementMap.$potentialElement
                        Content = "$($myParameterCopy.$potentialElement)"                    
                    }
                    if ($ElementAttributeMap.$potentialElement) {
                        $ElementSplat.Attribute = $ElementAttributeMap.$potentialElement
                    }
                    Template.HTML.Element @ElementSplat
                }
            }        

            if ($parameter -is [Collections.IDictionary]) {
                $parameter.Values | Template.HTML.Parameter.Input
            } elseif ($Parameter) {
                $Parameter | Template.HTML.Parameter.Input
            })
            
        $ContainerContent = 
            @(foreach ($itemInContainer in $ItemsInContainer) {
                if ($ItemElement) {
                    Template.HTML.Element -Name $ItemElement -Content $itemInContainer -Attribute $ItemAttribute
                } else {
                    $itemInContainer
                }                       
            }) -join $ItemSeparator

        if ($ContainerElement) {
            Template.HTML.Element -Name $ContainerElement -Content $ContainerContent -Attribute $ContainerAttribute
        } else {
            $ContainerContent
        }
    }
}