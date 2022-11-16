This directory and it's subdirectories contain the Transpilers that ship with PipeScript.

Transpilers should have the extension ```.psx.ps1```

Any other module can define it's own Transpilers.

All the module needs to do for the transpilers to be recognized by PipeScript is add PipeScript to the ```.PrivateData.PSData.Tags``` section of the module's manifest file.

This directory includes uncategorized or 'common' transpilers.


|DisplayName                             |Synopsis                                                             |
|----------------------------------------|---------------------------------------------------------------------|
|[Decorate](Decorate.psx.ps1)            |[decorate transpiler](Decorate.psx.ps1)                              |
|[Define](Define.psx.ps1)                |[defines a variable](Define.psx.ps1)                                 |
|[Explicit](Explicit.psx.ps1)            |[Makes Output from a PowerShell function Explicit.](Explicit.psx.ps1)|
|[Help](Help.psx.ps1)                    |[Help Transpiler](Help.psx.ps1)                                      |
|[Include](Include.psx.ps1)              |[Includes Files](Include.psx.ps1)                                    |
|[Inherit](Inherit.psx.ps1)              |[Inherits a Command](Inherit.psx.ps1)                                |
|[OutputFile](OutputFile.psx.ps1)        |[Outputs to a File](OutputFile.psx.ps1)                              |
|[ProxyCommand](ProxyCommand.psx.ps1)    |[Creates Proxy Commands](ProxyCommand.psx.ps1)                       |
|[RenameVariable](RenameVariable.psx.ps1)|[Renames variables](RenameVariable.psx.ps1)                          |
|[Rest](Rest.psx.ps1)                    |[Generates PowerShell to talk to a REST api.](Rest.psx.ps1)          |



### Examples

#### Decorate Example 1


~~~PowerShell
    {
        $v = [PSCustomObject]@{}
        [decorate('MyTypeName',Clear,PassThru)]$v
    }.Transpile()
~~~

#### Define Example 1


~~~PowerShell
    {
        [Define(Value={Get-Random})]$RandomNumber
    }.Transpile()
~~~

#### Define Example 2


~~~PowerShell
    {
        [Define(Value={$global:ThisValueExistsAtBuildTime})]$MyVariable
    }.Transpile()
~~~

#### Explicit Example 1


~~~PowerShell
    Invoke-PipeScript {
        [explicit()]
        param()
        "This Will Not Output"
        Write-Output "This Will Output"
    }
~~~

#### Explicit Example 2


~~~PowerShell
    {
        [explicit]{
            1,2,3,4
            echo "Output"
        }
    } | .>PipeScript
~~~

#### Help Example 1


~~~PowerShell
    {
        [Help(Synopsis="The Synopsis", Description="A Description")]
        param()

        
        "This Script Has Help, Without Directly Writing Comments"
        
    } | .>PipeScript
~~~

#### Help Example 2


~~~PowerShell
    {
        param(
        [Help(Synopsis="X Value")]
        $x
        )
    } | .>PipeScript
~~~

#### Help Example 3


~~~PowerShell
    {
        param(
        [Help("X Value")]
        $x
        )
    } | .>PipeScript
~~~

#### Include Example 1


~~~PowerShell
    {
        [Include("Invoke-PipeScript")]$null
    } | .>PipeScript
~~~

#### Include Example 2


~~~PowerShell
    {
        [Include("Invoke-PipeScript")]
        param()
    } | .>PipeScript
~~~

#### Include Example 3


~~~PowerShell
    {
        [Include('*-*.ps1')]$psScriptRoot
    } | .>PipeScript
~~~

#### Inherit Example 1


~~~PowerShell
    Invoke-PipeScript {
        [inherit("Get-Command")]
        param()
    }
~~~

#### Inherit Example 2


~~~PowerShell
    {
        [inherit("gh",Overload)]
        param()
        begin { "ABOUT TO CALL GH"}
        end { "JUST CALLED GH" }
    }.Transpile()
~~~

#### Inherit Example 3


~~~PowerShell
    # Inherit Get-Transpiler abstractly and make it output the parameters passed in.
    {
        [inherit("Get-Transpiler", Abstract)]
        param() process { $psBoundParameters }
    }.Transpile()
~~~

#### Inherit Example 4


~~~PowerShell
    {
        [inherit("Get-Transpiler", Dynamic, Abstract)]
        param()
    } | .>PipeScript
~~~

#### OutputFile Example 1


~~~PowerShell
    Invoke-PipeScript {
        [OutputFile("hello.txt")]
        param()

        'hello world'
    }
~~~

#### OutputFile Example 2


~~~PowerShell
    Invoke-PipeScript {
        param()

        $Message = 'hello world'
        [Save(".\Hello.txt")]$Message
    }
~~~

#### ProxyCommand Example 1


~~~PowerShell
    .\ProxyCommand.psx.ps1 -CommandName Get-Process
~~~

#### ProxyCommand Example 2


~~~PowerShell
    {
        function [ProxyCommand<'Get-Process'>]GetProcessProxy {}
    } | .>PipeScript
~~~

#### ProxyCommand Example 3


~~~PowerShell
    .>ProxyCommand -CommandName Get-Process -RemoveParameter *
~~~

#### ProxyCommand Example 4


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {[ProxyCommand('Get-Process')]param()}
~~~

#### ProxyCommand Example 5


~~~PowerShell
    Invoke-PipeScript -ScriptBlock {
        [ProxyCommand('Get-Process', 
            RemoveParameter='*',
            DefaultParameter={
                @{id='$pid'}
            })]
            param()
    }
~~~

#### ProxyCommand Example 6


~~~PowerShell
    { 
        function Get-MyProcess {
            [ProxyCommand('Get-Process', 
                RemoveParameter='*',
                DefaultParameter={
                    @{id='$pid'}
                })]
                param()
        } 
    } | .>PipeScript
~~~

#### RenameVariable Example 1


~~~PowerShell
    {
        [RenameVariable(VariableRename={
            @{
                x='x1'
                y='y1'
            }
        })]
        param($x, $y)
    } | .>PipeScript
~~~

#### Rest Example 1


~~~PowerShell
    {
        function Get-Sentiment {
            [Rest("http://text-processing.com/api/sentiment/",
                ContentType="application/x-www-form-urlencoded",
                Method = "POST",
                BodyParameter="Text",
                ForeachOutput = {
                    $_ | Select-Object -ExpandProperty Probability -Property Label
                }
            )]
            param()
        } 
    } | .>PipeScript | Set-Content .\Get-Sentiment.ps1
~~~

#### Rest Example 2


~~~PowerShell
    Invoke-PipeScript {
        [Rest("http://text-processing.com/api/sentiment/",
            ContentType="application/x-www-form-urlencoded",
            Method = "POST",
            BodyParameter="Text",
            ForeachOutput = {
                $_ | Select-Object -ExpandProperty Probability -Property Label
            }
        )]
        param()
    } -Parameter @{Text='wow!'}
~~~

#### Rest Example 3


~~~PowerShell
    {
        [Rest("https://api.github.com/users/{username}/repos",
            QueryParameter={"type", "sort", "direction", "page", "per_page"}
        )]
        param()
    } | .>PipeScript
~~~

#### Rest Example 4


~~~PowerShell
    Invoke-PipeScript {
        [Rest("https://api.github.com/users/{username}/repos",
            QueryParameter={"type", "sort", "direction", "page", "per_page"}
        )]
        param()
    } -UserName StartAutomating
~~~

#### Rest Example 5


~~~PowerShell
    {
        [Rest("http://text-processing.com/api/sentiment/",
            ContentType="application/x-www-form-urlencoded",
            Method = "POST",
            BodyParameter={@{
                Text = '
                    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
                    [string]
                    $Text
                '
            }})]
        param()
    } | .>PipeScript
~~~




