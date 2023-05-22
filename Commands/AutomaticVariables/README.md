Automatic Variables Commands allow the definition of an automatic variable.

Instead of these commands being run directly, they will be embedded inline.

Automatic Variables are embedded by [PostProcess.InitializeAutomaticVariable](docs/PostProcess.InitializeAutomaticVariable.md).


|VariableName                                                       |Description                                                                                                                                          |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|[CallstackPeek](/docs/Automatic.Variable.CallstackPeek.md)         |$MyCaller (aka $CallStackPeek) contains the CallstackFrame that called this command.                                                                 |
|[IsPipedFrom](/docs/PipeScript.Automatic.Variable.IsPipedFrom.md)  |$IsPipedFrom is an automatic variable that determines if the pipeline continues after this command.                                                  |
|[IsPipedTo](/docs/PipeScript.Automatic.Variable.IsPipedTo.md)      |$IsPipedTo is an automatic variable that determines if a command is being piped to.                                                                  |
|[MyCaller](/docs/PipeScript.Automatic.Variable.MyCaller.md)        |$MyCaller is an automatic variable that contains the CallstackFrame that called this command.<br/>        Also Known As:<br/>        * $CallStackPeek|
|[MyCallstack](/docs/PipeScript.Automatic.Variable.MyCallstack.md)  |$MyCallstack is an automatic variable that contains the current callstack.                                                                           |
|[MyCommandAst](/docs/PipeScript.Automatic.Variable.MyCommandAst.md)|$MyCommandAst is an automatic variable that contains the abstract syntax tree used to invoke this command.                                           |
|[MyParameters](/docs/PipeScript.Automatic.Variable.MyParameters.md)|$MyParameters is an automatic variable that is a copy of $psBoundParameters.<br/>        This leaves you more free to change it.                     |
|[MySelf](/docs/PipeScript.Automatic.Variable.MySelf.md)            |$MySelf is an automatic variable that contains the currently executing ScriptBlock.<br/>        A Command can & $myself to use anonymous recursion.  |



