Language function PowerShellXML {
<#
.SYNOPSIS
    PowerShellXML Language Definition
.DESCRIPTION
    Allows PipeScript to generate PS1XML.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
.EXAMPLE
    $typesFile, $typeDefinition, $scriptMethod = Invoke-PipeScript {

        types.ps1xml template '
        <Types>
            <!--{param([Alias("TypeDefinition")]$TypeDefinitions) $TypeDefinitions }-->
        </Types>
        '

        typeDefinition.ps1xml template '
        <Type>
            <!--{param([Alias("PSTypeName")]$TypeName) "<Name>$($typename)</Name>" }-->
            <!--{param([Alias("PSMembers","Member")]$Members) "<Members>$($members)</Members>" }-->
        </Type>
        '

        scriptMethod.ps1xml template '
        <ScriptMethod>
            <!--{param([Alias("Name")]$MethodName) "<Name>$($MethodName)</Name>" }-->
            <!--{param([ScriptBlock]$MethodDefinition) "<Script>$([Security.SecurityElement]::Escape("$MethodDefinition"))</Script>" }-->
        </ScriptMethod>
        '
    }


    $typesFile.Save("Test.types.ps1xml",
        $typeDefinition.Evaluate(@{
            TypeName='foobar'
            Members = 
                @($scriptMethod.Evaluate(
                    @{
                        MethodName = 'foo'
                        MethodDefinition = {"foo"}
                    }
                ),$scriptMethod.Evaluate(
                    @{
                        MethodName = 'bar'
                        MethodDefinition = {"bar"}
                    }
                ),$scriptMethod.Evaluate(
                    @{
                        MethodName = 'baz'
                        MethodDefinition = {"baz"}
                    }
                ))
        })
    )
#>
[ValidatePattern('\.ps1xml$')]
param()
$FilePattern = '\.ps1xml$'
# We start off by declaring a number of regular expressions:
$startComment = '<\!--' # * Start Comments ```<!--```
$endComment   = '-->'   # * End Comments   ```-->```
$Whitespace   = '[\s\n\r]{0,}'
# * StartPattern     ```$StartComment + '{' + $Whitespace```
$startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
# * EndPattern       ```$whitespace + '}' + $EndComment```
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
}
