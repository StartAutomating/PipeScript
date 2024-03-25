[ValidatePattern("(?>HTML|JavaScript)")]
param()


function Template.HTML.CustomElement {

    <#
    .SYNOPSIS
        Template for a custom HTML element.
    .DESCRIPTION
        A Template for a custom HTML element.

        Creates the JavaScript for a custom HTML element.
    .LINK
        https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements
    .EXAMPLE
        Template.HTML.CustomElement -ElementName hello-world -Template "<p>Hello, World!</p>"  -OnConnected "
            console.log('Hello, World!')
        "
        Template.HTML.Element -Name "hello-world"
    #>
    [Alias(
        'Template.HTML.Control',
        'Template.Control.html',
        'Template.CustomElement.html',
        'Template.JavaScript.Control',
        'Template.JavaScript.CustomElement',
        'Template.Control.js',        
        'Template.CustomElement.js'
    )]
    param(
    # The name of the element.  By default, custom-element.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Element','Name')]
    [string]
    $ElementName = 'custom-element',

    # The class name.
    # If not provided, it will be derived from the element name.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Class')]
    [string]
    $ClassName,
    
    # The class that the element extends.  By default, HTMLElement.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Extends','Extend')]
    [string]
    $ExtendClass = 'HTMLElement',

    # The base HTML element that is being extended.
    # If a specific element is extended, you can create a control in form:
    # ~~~html
    # <ElementName is="custom-element"></ElementName>
    # ~~~
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ExtendElements')]
    [string]
    $ExtendElement,

    # The parameters to any template.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters')]
    [PSObject]
    $Parameter,

    # The properties for the element.
    # If multiple values are provided, the property will be gettable and settable.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Properties')]
    [PSObject[]]
    $Property,

    # Any additional members for the element.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Methods')]
    [PSObject[]]
    $Method,

    # Any additional fields for the element.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fields')]
    [PSObject[]]
    $Field,

    # The template content, or the ID of a template.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('TemplateID','TemplateContent','Content')]
    [string]
    $Template,

    # The JavaScript to run when the element is connected.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('OnConnection','ConnectedCallback', 'ConnectionCallback')]
    [string]
    $OnConnected,

    # The JavaScript to run when the element is disconnected.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('OnDisconnection','DisconnectedCallback', 'DisconnectionCallback')]
    [string]
    $OnDisconnected,

    # The JavaScript to run when the element is adopted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('OnAdoption','AdoptedCallback', 'AdoptionCallback')]
    [string]
    $OnAdopted,

    # The JavaScript to run when attributes are updated.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('OnAttributeChanged','AttributeChangeCallback', 'AttributeChangedCallback')]
    [string]
    $OnAttributeChange,

    # A collection of event handlers.
    # Each key or property will be the element ID (followed by a period) and the event name.
    # Multiple event names can be separated by commas.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('EventHandlers')]
    [PSObject]
    $EventHandler,

    # The list of observable attributes.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ObservableAttributes','Observable')]
    [string[]]
    $ObservableAttribute
    )

    process {
        if (-not $PSBoundParameters['ClassName']) {
            $ClassName = $ElementName -replace '-','_'
        }

        $Field += @{"#shadow" = "this.attachShadow({mode: 'open'});"}
        if ($ObservableAttribute -and -not $OnAttributeChange) {
            foreach ($observerableAttr in $ObservableAttribute) {
                $defaultFieldName = "#$($observerableAttr -replace "-","_")"
                if (-not @($field.$defaultFieldName)) {
                    $Field += @{$defaultFieldName = "null"}    
                }
                $defaultPropertyName = "$($observerableAttr -replace "-","_")"
                if (-not @($Property.$defaultPropertyName)) {
                    $Property += @{$defaultPropertyName = @("return this.$defaultFieldName","this.$defaultFieldName = value") }
                }
            }
        }
                
        
        $allMembers = @(
            if ($field) {
                foreach ($PropertyBag in @($Field)) {
                    if ($PropertyBag -is [Collections.IDictionary]) {
                        $PropertyBag = [PSCustomObject]$PropertyBag
                    }
                    foreach ($prop in $PropertyBag.PSObject.properties) {
                        "$($prop.Name) = $($prop.Value)"
                    }
                }
            }

            if ($EventHandler) {
                if ($EventHandler -is [Collections.IDictionary]) {
                    $EventHandler = [PSCustomObject]([Ordered]@{} + $EventHandler)
                }
                $wireEventHandlers = foreach ($prop in $eventHandler.psobject.properties) {
                    if ($prop.Name -notmatch '\.') { continue }
                    $propNameSegements = $prop.Name -split '\.'
                    if ($propNameSegements.Count -lt 2) { continue }
                    $elementId = $propNameSegements[0..($propNameSegements.Count - 2)] -join '.'
                    $eventNames = $propNameSegements[-1] -split '\s{0,},\s{0,}'
                    $eventHandlerScript = $prop.Value
                    if ($eventHandlerScript -notmatch 'function') {
                        $eventHandlerScript = "function(event) { $eventHandlerScript }"
                        if ($eventHandlerScript -notmatch '.bind(this)\s{0,}$') {
                            $eventHandlerScript = "$eventHandlerScript.bind(this)"                        
                        }
                    }
                    foreach ($eventName in $eventnames) {
                        @("this.#shadow.getElementById(`"$elementId`").addEventListener("
                        "    `"$eventName`","
                        "    $eventHandlerScript"
                        ");") -join [Environment]::NewLine
                    }                    
                }
                if ($OnConnected) {
                    $OnConnected = $wireEventHandlers, $OnConnected -join [Environment]::NewLine
                }
            }
    
            if ($OnConnected) {
                "connectedCallback() { $OnConnected }"
            }
            if ($OnDisconnected) {
                "disconnectedCallback() { $OnDisconnected }"
            }            
            if ($OnAdopted) {
                "adoptedCallback() { $OnAdopted }"
            }
            if ($ObservableAttribute) {
                "static get observedAttributes() { return $(ConvertTo-Json -InputObject $ObservableAttribute -Compress) }"
            }
            if ($OnAttributeChange) {
                "attributeChangedCallback(name, oldValue, newValue) { $OnAttributeChange }"
            } elseif ($ObservableAttribute) {
                "attributeChangedCallback(name, oldValue, newValue) { 
                    this.setAttribute(name, newValue);
                    if (this[name.replace('-','_')] && this[name.replace('-','_')] != newValue) {
                        this[name.replace('-','_')] = newValue;
                    }
                }"
            }
            
            if ($property) {
                foreach ($PropertyBag in @($Property)) {
                    if ($PropertyBag -is [Collections.IDictionary]) {
                        $PropertyBag = [PSCustomObject]$PropertyBag
                    }
                    foreach ($prop in $PropertyBag.PSObject.properties) {
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
            }
    
            if ($method) {
                foreach ($MemberBag in @($method)) {
                    if ($MemberBag -is [Collections.IDictionary]) {
                        $MemberBag = [PSCustomObject]$MemberBag
                    }
                    foreach ($member in $MemberBag.PSObject.properties) {
                        $memberName = $member.Name
                        $memberValue = $member.Value
                        if ($memberValue -notmatch '\s{0,}\{') {
                            $memberValue = "{ $memberValue }"
                        }
                        "$memberName $memberValue"
                    }
                }
            }    
        )

        @"
$(if ($MyInvocation.InvocationName -match 'HTML') {'<script type="module">/*<![CDATA[*/'})
class $ClassName extends $ExtendClass {
    constructor() {
        super();
        
        let shadowTemplate = $(
            if ($template -match '[\r\n]') {
                "document.createRange().createContextualFragment(``$Template``);"
            } elseif ($template -match '^\#') {
                "document.getElementById(``$Template``);"
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
                "document.createRange().createContextualFragment(``$TemplateOutput``);"
            } elseif (Test-Path $template) {
                "document.createRange().createContextualFragment(``$(Get-Content $Template -Raw)``);"
            } else {
                "document.createRange().createContextualFragment(``$Template``);"
            }
        )
        this.#shadow.appendChild(shadowTemplate.cloneNode(true));
    }
    $($allMembers -join ([Environment]::NewLine * 2))
}

if (customElements.define != null) {
    $(
        if ($ExtendElement) {
            "customElements.define(`"$ElementName`", $ClassName, {extends: `"$ExtendElement`"});"
        } else {
            "customElements.define(`"$ElementName`", $ClassName);"
        }
    )    
}
$(if ($MyInvocation.InvocationName -match 'HTML') {'/*]]>*/'})
</script>
"@
    }

}


