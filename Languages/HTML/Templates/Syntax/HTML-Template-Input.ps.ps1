[ValidatePattern('HTML')]
param()

Template function HTML.Input {
    <#
    .SYNOPSIS
        Template for an HTML input.
    .DESCRIPTION
        A Template for an HTML input element.
    .LINK
        https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
    #>
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # The type of input.
    [vbn()]
    [ValidateSet("button","checkbox","color","date","datetime-local","email","file","hidden","image","month","number","password","radio","range","reset","search","submit","tel","text","time","url","week")]
    [string]
    $InputType,

    # The ID of the input.
    [vbn()]
    [string]
    $ID,

    # The name of the input.
    [vbn()]
    [string]
    $Name,

    # The value of the input.
    [vbn()]
    [string]
    $Value,

    # The placeholder of the input.
    [vbn()]
    [string]
    $Placeholder,

    # If the input is required.
    [vbn()]
    [switch]
    $Required,

    # If the input is disabled.
    [vbn()]
    [switch]
    $Disabled,

    # If the input is readonly.
    [vbn()]
    [switch]
    $ReadOnly,

    # If the input is checked.
    [vbn()]
    [switch]
    $Checked,

    # The minimum value of the input.
    [vbn()]
    [string]
    $Min,

    # The maximum value of the input.
    [vbn()]
    [string]
    $Max,

    # The step value of the input.
    [vbn()]
    [string]
    $Step,

    # The pattern of the input.
    [vbn()]
    [string]
    $Pattern,

    # The autocomplete of the input.
    [vbn()]
    [ValidateSet("on","off")]
    [string]
    $AutoComplete,

    # The form that the input is associated with.
    [vbn()]
    [string]
    $Form,

    # The formaction of the input.
    [vbn()]
    [string]
    $FormAction,

    # The formenctype of the input.
    [vbn()]
    [Alias('FormEnc','FormEncType')]
    [ValidateSet("application/x-www-form-urlencoded","multipart/form-data","text/plain")]
    [string]
    $FormEncodingType,

    # The formmethod of the input.
    [vbn()]
    [Alias('FormMeth')]
    [ValidateSet("get","post")]
    [string]
    $FormMethod,

    # The formnovalidate of the input.
    [vbn()]
    [switch]
    $FormNoValidate,

    # The formtarget of the input.
    [vbn()]
    [Alias('FormTarg')]
    [ValidateSet("_blank","_self","_parent","_top")]
    [string]
    $FormTarget,

    # The height of the input.
    [vbn()]
    [string]
    $Height,

    # The width of the input.
    [vbn()]
    [string]
    $Width,

    # The list of the input.
    [vbn()]
    [string]
    $List,

    # The minimum length of the input.
    [vbn()]
    [Alias('MinimumLength')]
    [int]
    $MinLength,

    # If set, an email input can accept multiple emails, or a file input can accept multiple files.
    [vbn()]
    [switch]
    $Multiple,

    # The size of the input.
    [vbn()]
    [string]
    $Size,

    # The accept of the input.
    [vbn()]
    [string]
    $Accept,

    # The accept-charset of the input.
    [vbn()]
    [string]
    $AcceptCharset,
    
    # The autofocus of the input.
    [vbn()]
    [switch]
    $AutoFocus,

    [vbn()]
    [Alias('Alt')]
    [string]
    $AlternateText
    )

    process {
        $InputAttributes = @(
            if ($ID) { "id='$ID'" }
            if ($inputType) { "type='$inputType'" }
            if ($name) { "name='$name'" }
            if ($value) { "value='$value'" }
            if ($placeholder) { "placeholder='$placeholder'" }
            if ($required) { "required" }
            if ($disabled) { "disabled" }
            if ($readOnly) { "readonly" }
            if ($checked) { "checked" }
            if ($min) { "min='$min'" }
            if ($max) { "max='$max'" }
            if ($step) { "step='$step'" }
            if ($pattern) { "pattern='$pattern'" }
            if ($autoComplete) { "autocomplete='$autoComplete'" }
            if ($form) { "form='$form'" }
            if ($formAction) { "formaction='$formAction'" }
            if ($formEncodingType) { "formenctype='$formEncodingType'" }
            if ($formMethod) { "formmethod='$formMethod'" }
            if ($formNoValidate) { "formnovalidate" }
            if ($formTarget) { "formtarget='$formTarget'" }
            if ($height) { "height='$height'" }
            if ($width) { "width='$width'" }
            if ($list) { "list='$list'" }
            if ($multiple) { "multiple" }
            if ($size) { "size='$size'" }
            if ($accept) { "accept='$accept'" }
            if ($acceptCharset) { "accept-charset='$acceptCharset'" }
            if ($autoFocus) { "autofocus" }            
        ) -join ' '

        "<input$(if ($InputAttributes) { " $InputAttributes" }) />"
    }
}