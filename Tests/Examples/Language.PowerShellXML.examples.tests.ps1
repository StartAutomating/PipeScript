
describe 'Language.PowerShellXML' {
    it 'Language.PowerShellXML Example 1' {
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
    }
}

