This directory and it's subdirectories contain Transpilers that transform parameter attributes.

Parameter Transpilers do not need to take any values from the pipeline.
They will be called by the Core PipeScript Transpiler ```PipeScript.ParameterAttribute```.

When Transpiling a Parameter, the Transpiler should return one of two things.

1. An empty ```[ScriptBlock]``` preceeded by attributes or help.  This will replace the Transpiled attribute with a real one.
2. A ```[Collections.IDictionary]``` can be used to send arguments directly back to ```Update-PipeScript```.

Many parameter transpilers can also apply to a ```[Management.Automation.Language.VariableExpressionAst]```.  

When this is the case it is common for the transpiler to add a ```[ValidateScript]``` attribute to the variable.  This will constraint the value of that variable.

## List Of Parameter Transpilers


|DisplayName                                         |Synopsis                                                             |
|----------------------------------------------------|---------------------------------------------------------------------|
|[ValidateExtension](ValidateExtension.psx.ps1)      |[Validates Extensions](ValidateExtension.psx.ps1)                    |
|[ValidatePlatform](ValidatePlatform.psx.ps1)        |[Validates the Platform](ValidatePlatform.psx.ps1)                   |
|[ValidatePropertyName](ValidatePropertyName.psx.ps1)|[Validates Property Names](ValidatePropertyName.psx.ps1)             |
|[ValidateTypes](ValidateTypes.psx.ps1)              |[Validates if an object is one or more types.](ValidateTypes.psx.ps1)|
|[VBN](VBN.psx.ps1)                                  |[ValueFromPipline Shorthand](VBN.psx.ps1)                            |
|[VFP](VFP.psx.ps1)                                  |[ValueFromPipline Shorthand](VFP.psx.ps1)                            |






