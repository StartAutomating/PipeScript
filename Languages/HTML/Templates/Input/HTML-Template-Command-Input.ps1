[ValidatePattern('HTML')]
param()



function Template.HTML.Command.Input {

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
    [Parameter(Mandatory,ParameterSetName='CommandMetadata',ValueFromPipeline)]
    [Management.Automation.CommandMetadata]
    $CommandMetadata,

    # The name of the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CommandName')]
    [string]
    $Name,

    # If the command supports ShouldProcess (`-WhatIf`, `-Confirm`)
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $SupportsShouldProcess,

    # If the command supports paging.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $SupportsPaging,

    # If the command supports positional binding
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $PositionalBinding,

    # The help URI for the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $HelpUri,

    # The confirm impact of the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Management.Automation.ConfirmImpact]
    $ConfirmImpact,

    # The parameter metadata for the command.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters')]
    [PSObject]
    $Parameter,

    # The Command Description.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CommandDescription')]
    [string]
    $Description,

    # The Command Synopsis.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CommandSynopsis')]
    [string]
    $Synopsis,

    # The Command Example.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('CommandExample')]
    [string[]]
    $Example,

    # The Command Notes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Note','CommandNotes')]
    [string[]]
    $Notes,

    # The Command Links.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Links','CommandLinks')]
    [string[]]
    $Link,
    
    # The Element Map.
    # This maps parameters to the HTML elements that will be used to render them.    
    [Parameter(ValueFromPipelineByPropertyName)]
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
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject]
    $ElementAttributeMap = [Ordered]@{
        'Example' = [Ordered]@{
            'class' = 'language-powershell'
            'language' = 'PowerShell'
        }
    },

    # The element separator.  This is used to separate elements.
    [Parameter(ValueFromPipelineByPropertyName)]
    [psobject]
    $ElementSeparator,
    
    # The Command Attributes.  These are used to provide additional information about the command.
    # They will be automatically provided if piping a command into this function.
    # If an attribute named HTML.Input is provided, it will be returned directly.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Attributes','CommandAttribute','CommandAttributes')]
    [PSObject[]]
    $Attribute,

    # The Container Element.  This is used to hold all of the elements.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ContainerElement,

    # The Container Attributes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $ContainerAttribute,

    # The Item Element.  This is used to hold each item.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $ItemElement,

    # The Item Attributes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $ItemAttribute,

    # The Item Separator.  This is used to separate items.
    # The default is a line break.
    [Parameter(ValueFromPipelineByPropertyName)]
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


        # Then copy the parameters
        $myParameterCopy = [Ordered]@{} + $PSBoundParameters
        $elementOrder    = 
            @(if ($elementMap -is [Collections.IDictionary]) {
                $elementMap.Keys
            } else {
                $elementMap.PSObject.Properties.Name
            })


        
        $ItemsInContainer = @(
            # Many parameters will be turned directly into elements,
            # using the -ElementMap and -ElementAttributeMap
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

            # Any parameters should be turned into input elements.
            if ($parameter -is [Collections.IDictionary]) {                
                $parameter.Values | Template.HTML.Parameter.Input
            } elseif ($Parameter) {
                $Parameter | Template.HTML.Parameter.Input
            }
        )
            
        # Now we want to put all of the items into a container.
        $ContainerContent = 
            @(foreach ($itemInContainer in $ItemsInContainer) {
                # If we have an item element, wrap it in that element.
                if ($ItemElement) {
                    Template.HTML.Element -Name $ItemElement -Content $itemInContainer -Attribute $ItemAttribute
                } else {
                    $itemInContainer
                }                       
            }) -join $ItemSeparator # If we have an item separator, join the items with it.

        # If we have a container element, wrap the all the items in that element.
        if ($ContainerElement) {
            Template.HTML.Element -Name $ContainerElement -Content $ContainerContent -Attribute $ContainerAttribute
        } else {
            $ContainerContent # Otherwise, return the items directly.
        }
    }

}

