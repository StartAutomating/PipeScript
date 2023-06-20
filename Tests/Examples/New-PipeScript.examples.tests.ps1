
describe 'New-PipeScript' {
    it 'New-PipeScript Example 1' {
        New-PipeScript -Parameter @{a='b'}
    }
    it 'New-PipeScript Example 2' {
        New-PipeScript -Parameter ([Net.HttpWebRequest].GetProperties()) -ParameterHelp @{
            Accept='
HTTP Accept.
HTTP Accept indicates what content types the web request will accept as a response.
'
        }
    }
    it 'New-PipeScript Example 3' {
        New-PipeScript -Parameter @{"bar"=@{
            Name = "foo"
            Help = 'Foobar'
            Attributes = "Mandatory","ValueFromPipelineByPropertyName"
            Aliases = "fubar"
            Type = "string"
        }}
    }
    it 'New-PipeScript Example 4' {
        New-PipeScript -FunctionName New-TableControl -Parameter (
            [Management.Automation.TableControl].GetProperties()
        ) -Process {
            New-Object Management.Automation.TableControl -Property $psBoundParameters
        }
    }
}

