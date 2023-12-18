
describe 'New-PipeScript' {
    it 'New-PipeScript Example 1' {
        # Without any parameters, this will make an empty script block
        New-PipeScript |  Should -BeOfType([ScriptBlock])
    }
    it 'New-PipeScript Example 2' {
        # We can use -AutoParameter to automatically populate parameters:
        New-PipeScript -ScriptBlock { $x + $y} -AutoParameter
    }
    it 'New-PipeScript Example 3' {
        # We can use -AutoParameter and -AutoParameterType to automatically make all parameters a specific type:
        New-PipeScript -ScriptBlock { $x, $y } -AutoParameter -AutoParameterType double
    }
    it 'New-PipeScript Example 4' {
        # We can provide a -FunctionName to make a function.
        # New-PipeScript transpiles the scripts it generates, so this will also declare the function.
        New-PipeScript -ScriptBlock { Get-Random -Min 1 -Max 20 } -FunctionName ANumberBetweenOneAndTwenty
        ANumberBetweenOneAndTwenty |  Should -BeLessThan 21
    }
    it 'New-PipeScript Example 5' {
        # We can provide parameters as a dictionary.                
        New-PipeScript -Parameter @{"foo"=@{
            Name = "foo"
            Help = 'Foobar'
            Attributes = "Mandatory","ValueFromPipelineByPropertyName"
            Aliases = "fubar"
            Type = "string"
        }}
    }
    it 'New-PipeScript Example 6' {
        # We can provide parameters from .NET reflection.
        # We can provide additional parameter help with -ParameterHelp
        New-PipeScript -Parameter ([Net.HttpWebRequest].GetProperties()) -ParameterHelp @{
            Accept='
HTTP Accept.

HTTP Accept indicates what content types the web request will accept as a response.
'
        }
    }
    it 'New-PipeScript Example 7' {
        # If a .NET type has XML Documentation, this can generate parameter help.
        New-PipeScript -FunctionName New-TableControl -Parameter (
            [Management.Automation.TableControl].GetProperties()
        ) -Process {
            New-Object Management.Automation.TableControl -Property $psBoundParameters
        } -Synopsis 'Creates a table control'

        Get-Help New-TableControl -Parameter *
    }
    it 'New-PipeScript Example 8' {
        $CreatedCommands = 
            [Management.Automation.TableControl],
                [Management.Automation.TableControlColumnHeader],
                [Management.Automation.TableControlRow],
                [Management.Automation.TableControlColumn],
                [Management.Automation.DisplayEntry] |
                    New-PipeScript -Noun { $_.Name } -Verb New -Alias {
                        "Get-$($_.Name)", "Set-$($_.Name)"
                    } -Synopsis {
                        "Creates, Changes, or Gets $($_.Name)"
                    }

        
        New-TableControl -Headers @(
            New-TableControlColumnHeader -Label "First" -Alignment Left -Width 10
            New-TableControlColumnHeader -Label "Second" -Alignment Center -Width 20
            New-TableControlColumnHeader -Label "Third" -Alignment Right -Width 20
        ) -Rows @(
            New-TableControlRow -Columns @(
                New-TableControlColumn -DisplayEntry (
                    New-DisplayEntry First Property
                )
                New-TableControlColumn -DisplayEntry (
                    New-DisplayEntry Second Property
                )
                New-TableControlColumn -DisplayEntry (
                    New-DisplayEntry Third Property
                )
            )
        )
    }
}

