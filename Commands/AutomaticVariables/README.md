Automatic Variables Commands allow the definition of an automatic variable.

Instead of these commands being run directly, they will be embedded inline.

Automatic Variables are embedded in post processing by [PostProcess.InitializeAutomaticVariable](docs/PostProcess.InitializeAutomaticVariable.md).


|VariableName                                                       |Description                                                                                                          |
|-------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
|[](/docs/Automatic.Variable.CallstackPeek.md)                      |$MyCaller (aka $CallStackPeek) contains the CallstackFrame that called this command.                                 |
|[IsPipedFrom](/docs/PipeScript.Automatic.Variable.IsPipedFrom.md)  |$IsPipedFrom determines if the pipeline continues after this command.                                                |
|[IsPipedTo](/docs/PipeScript.Automatic.Variable.IsPipedTo.md)      |$IsPipedTo determines if a command is being piped to.                                                                |
|[MyCaller](/docs/PipeScript.Automatic.Variable.MyCaller.md)        |$MyCaller (aka $CallStackPeek) contains the CallstackFrame that called this command.                                 |
|[MyCallstack](/docs/PipeScript.Automatic.Variable.MyCallstack.md)  |$MyCallstack is an automatic variable that contains the current callstack.                                           |
|[MyCommandAst](/docs/PipeScript.Automatic.Variable.MyCommandAst.md)|$MyCommandAst contains the abstract syntax tree used to invoke this command.                                         |
|[MyParameters](/docs/PipeScript.Automatic.Variable.MyParameters.md)|$MyParameters contains a copy of $psBoundParameters.<br/>        This leaves you more free to change it.             |
|[MySelf](/docs/PipeScript.Automatic.Variable.MySelf.md)            |$MySelf contains the currently executing ScriptBlock.<br/>        A Command can & $myself to use anonymous recursion.|



