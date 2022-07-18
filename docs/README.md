This directory and it's subdirectories contain Transpilers that transform parameter attributes.

Parameter Transpilers do not need to take any values from the pipeline.
They will be called by the Core PipeScript Transpiler ```PipeScript.ParameterAttribute```.

When Transpiling a Parameter, the Transpiler should return one of two things.

1. An empty ```[ScriptBlock]``` preceeded by attributes or help.  This will replace the Transpiled attribute with a real one.
2. A ```[Collections.IDictionary]``` can be used to send arguments directly back to ```Update-PipeScript```.

Many parameter transpilers can also apply to a ```[Management.Automation.Language.VariableExpressionAst]```.  

When this is the case it is common for the transpiler to add a ```[ValidateScript]``` attribute to the variable.  This will constraint the value of that variable.

## List Of Parameter Transpilers


|Table|
|-----|
||






