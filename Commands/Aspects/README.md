## Aspects in PipeScript

An Aspect is a small, resuable function.

Aspects are meant to be embedded within other code, though they can also be used interactively.

When a file is built, any aspects will be consolidated and embedded inline.


|Name                                                                   |Synopsis                                                                      |
|-----------------------------------------------------------------------|------------------------------------------------------------------------------|
|[Aspect.DynamicParameters](/docs/Aspect.DynamicParameters.md)          |[Dynamic Parameter Aspect](/docs/Aspect.DynamicParameters.md)                 |
|[Aspect.ModuleCommandTypes](/docs/Aspect.ModuleCommandTypes.md)        |[Outputs a module's extension types](/docs/Aspect.ModuleCommandTypes.md)      |
|[Aspect.ModuleCommandType](/docs/Aspect.ModuleCommandType.md)          |[Outputs a module's extension types](/docs/Aspect.ModuleCommandType.md)       |
|[Aspect.ModuleExtensionTypes](/docs/Aspect.ModuleExtensionTypes.md)    |[Outputs a module's extension types](/docs/Aspect.ModuleExtensionTypes.md)    |
|[Aspect.ModuleCommandPattern](/docs/Aspect.ModuleCommandPattern.md)    |[Outputs a module's extension pattern](/docs/Aspect.ModuleCommandPattern.md)  |
|[Aspect.ModuleExtendedCommand](/docs/Aspect.ModuleExtendedCommand.md)  |[Returns a module's extended commands](/docs/Aspect.ModuleExtendedCommand.md) |
|[Aspect.DynamicParameter](/docs/Aspect.DynamicParameter.md)            |[Dynamic Parameter Aspect](/docs/Aspect.DynamicParameter.md)                  |
|[Aspect.ModuleExtensionType](/docs/Aspect.ModuleExtensionType.md)      |[Outputs a module's extension types](/docs/Aspect.ModuleExtensionType.md)     |
|[Aspect.ModuleExtensionPattern](/docs/Aspect.ModuleExtensionPattern.md)|[Outputs a module's extension pattern](/docs/Aspect.ModuleExtensionPattern.md)|
|[Aspect.ModuleExtensionCommand](/docs/Aspect.ModuleExtensionCommand.md)|[Returns a module's extended commands](/docs/Aspect.ModuleExtensionCommand.md)|




## Aspect Examples

All of the current aspect examples are listed below:

## Aspect.DynamicParameters -> Aspect.DynamicParameter Example 1


~~~PowerShell
        Get-Command Get-Command | 
            Aspect.DynamicParameter
~~~

## Aspect.DynamicParameters -> Aspect.DynamicParameter Example 2


~~~PowerShell
        Get-Command Get-Process | 
            Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Keys | Should -Be Name
~~~

## Aspect.ModuleCommandTypes -> Aspect.ModuleExtensionType Example 1


~~~PowerShell
        # Outputs a PSObject with information about extension command types.
        
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
~~~

## Aspect.ModuleCommandType -> Aspect.ModuleExtensionType Example 1


~~~PowerShell
        # Outputs a PSObject with information about extension command types.
        
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
~~~

## Aspect.ModuleExtensionTypes -> Aspect.ModuleExtensionType Example 1


~~~PowerShell
        # Outputs a PSObject with information about extension command types.
        
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
~~~

## Aspect.ModuleCommandPattern -> Aspect.ModuleExtensionPattern Example 1


~~~PowerShell
        Aspect.ModuleCommandPattern -Module PipeScript # Should -BeOfType ([Regex])
~~~

## Aspect.ModuleExtendedCommand -> Aspect.ModuleExtensionCommand Example 1


~~~PowerShell
        Aspect.ModuleExtensionCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
~~~

##  Example 1


~~~PowerShell
        Get-Command Get-Command | 
            Aspect.DynamicParameter
~~~

##  Example 2


~~~PowerShell
        Get-Command Get-Process | 
            Aspect.DynamicParameter -IncludeParameter Name # Select -Expand Keys | Should -Be Name
~~~

##  Example 1


~~~PowerShell
        # Outputs a PSObject with information about extension command types.
        
        # The two primary pieces of information are the `.Name` and `.Pattern`.
        Aspect.ModuleExtensionType -Module PipeScript # Should -BeOfType ([PSObject])
~~~

##  Example 1


~~~PowerShell
        Aspect.ModuleCommandPattern -Module PipeScript # Should -BeOfType ([Regex])
~~~

##  Example 1


~~~PowerShell
        Aspect.ModuleExtensionCommand -Module PipeScript # Should -BeOfType ([Management.Automation.CommandInfo])
~~~



