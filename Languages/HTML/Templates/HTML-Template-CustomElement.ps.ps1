[ValidatePattern("HTML")]
param()

Template function HTML.CustomElement {
    <#
    .SYNOPSIS
        Template for a custom HTML element.
    .DESCRIPTION
        A Template for a custom HTML element.

        Creates the JavaScript for a custom HTML element.
    .LINK
        https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements
    #>
    [Alias('Template.HTML.Control','Template.Control.html','Template.CustomElement.html')]
    param(
    # The name of the element.  By default, custom-element.
    [vbn()]
    [Alias('Element','Name')]
    [string]
    $ElementName = 'custom-element',

    # The class name.
    # If not provided, it will be derived from the element name.
    [vbn()]
    [Alias('Class')]
    [string]
    $ClassName,
    
    # The class that the element extends.  By default, HTMLElement.
    [vbn()]
    [Alias('Extends','Extend')]
    [string]
    $ExtendClass = 'HTMLElement',

    # The base HTML element that is being extended.
    [vbn()]
    [Alias('ExtendElements')]
    [string]
    $ExtendElement = 'div',

    # The parameters to any template.
    [vbn()]
    [Alias('Parameters')]
    [PSObject]
    $Parameter,

    # The properties for the element.
    # If multiple values are provided, the property will be gettable and settable.
    [vbn()]
    [Alias('Properties')]
    [PSObject]
    $Property,

    # The template content, or the ID of a template.
    [vbn()]
    [Alias('TemplateID','TemplateContent','Content')]
    [string]
    $Template,

    # The JavaScript to run when the element is connected.
    [vbn()]
    [Alias('OnConnection','ConnectedCallback', 'ConnectionCallback')]
    [string]
    $OnConnected,

    # The JavaScript to run when the element is disconnected.
    [vbn()]
    [Alias('OnDisconnection','DisconnectedCallback', 'DisconnectionCallback')]
    [string]
    $OnDisconnected,

    # The JavaScript to run when the element is adopted.
    [vbn()]
    [Alias('OnAdoption','AdoptedCallback', 'AdoptionCallback')]
    [string]
    $OnAdopted,

    # The JavaScript to run when attributes are updated.
    [vbn()]
    [Alias('OnAttributeChanged','AttributeChangeCallback', 'AttributeChangedCallback')]
    [string]
    $OnAttributeChange,

    # The list of observable attributes.
    [vbn()]
    [Alias('ObservableAttributes','Observable')]
    [string[]]
    $ObservableAttribute
    )

    process {
        if (-not $PSBoundParameters['ClassName']) {
            $ClassName = $ElementName -replace '-','_'
        }

        @"
<script type="module">/*<![CDATA[*/
class $ClassName extends $ExtendClass {
    constructor() {
        super();
        const shadow = this.attachShadow({mode: 'open'});        
        $(
            if ($template -match '[\r\n]') {
                "shadow.innerHTML = ``$Template``;"
            } elseif ($template -match '^\#') {
                "shadow.innerHTML = document.getElementById(``$Template``).innerHTML;"
            } elseif ($(
                $templateCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand($Template,'Function,Alias')
                $templateCommand
            )) {
                $TemplateSplat = [Ordered]@{}
                if ($Parameter -isnot [Collections.IDictionary]) {
                    foreach ($prop in $Parameter.PSObject.properties) {
                        $TemplateSplat[$prop.Name] = $prop.Value
                    }
                }

                $TemplateOutput = & $TemplateCommand @TemplateSplat
                "shadow.innerHTML = ``$TemplateOutput``;"                
            } elseif (Test-Path $template) {
                "shadow.innerHTML = ``$(Get-Content $Template -Raw)``;"
            }
        )$(@(
            if ($OnConnected) {
                "connectedCallback() { $OnConnected }"
            }
            if ($OnDisconnected) {
                "disconnectedCallback() { $OnDisconnected }"
            }            
            if ($OnAdopted) {
                "adoptedCallback() { $OnAdopted }"
            }
            if ($OnAttributeChange) {
                "attributeChangedCallback(name, oldValue, newValue) { $OnAttributeChange }"
            }            
            if ($ObservableAttribute) {
                "static get observedAttributes() { return [`$($ObservableAttribute -join '`,`')`]; }"
            }
            if ($property) {
                if ($property -is [Collections.IDictionary]) {
                    $property = [PSCustomObject]$property
                }
                foreach ($prop in $property.PSObject.properties) {
                    $propName = $prop.Name                    
                    $propGet, $propSet = $prop.Value
                    if ($propGet) {
                        "get $propName() { $propGet }"
                    }
                    if ($propSet) {
                        "set $propName(value) { $propSet }"
                    }
                }
            }
        ) -join ([Environment]::NewLine * 2))
    }    
}

if (!customElements.get(`$ElementName`)) {
    customElements.define(`$ElementName`, $ClassName, { extends: `$ExtendElement` });
}
/*]]>*/
</script>
"@
    }
}
