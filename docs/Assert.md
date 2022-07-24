
Assert
------
### Synopsis
Assert keyword

---
### Description

Assert is a common keyword in many programming languages.

In PipeScript, Asset will take a condition and an optional action.

The condtion may be contained in either parenthesis or a [ScriptBlock].

If there is no action, the assertion will throw an exception containing the condition.

If the action is a string, the assertion will throw that error as a string.

If the action is a ScriptBlock, it will be run if the assertion is false.

Assertions will not be transpiled or included if -Verbose or -Debug has not been set.

Additionally, while running, Assertions will be ignored if -Verbose or -Debug has not been set.

---
### Examples
#### EXAMPLE 1
```PowerShell
# With no second argument, assert will throw an error with the condition of the assertion.
Invoke-PipeScript {
    assert (1 -eq 1)
} -Debug
```

#### EXAMPLE 2
```PowerShell
# With a second argument of a string, assert will throw an error
Invoke-PipeScript {
    assert ($true) "It's true"
} -Debug
```

#### EXAMPLE 3
```PowerShell
# Conditions can also be written as a ScriptBlock
Invoke-PipeScript {
    assert {$true} "Process id '$pid' Asserted"
} -Verbose
```

#### EXAMPLE 4
```PowerShell
# If the assertion action was a ScriptBlock, no exception is automatically thrown
Invoke-PipeScript {
    assert ($true) { Write-Information "Assertion was true"}
} -Verbose
```

---
### Parameters
#### **CommandAst**

The CommandAst



|Type              |Requried|Postion|PipelineInput |
|------------------|--------|-------|--------------|
|```[CommandAst]```|true    |named  |true (ByValue)|
---
### Syntax
```PowerShell
Assert -CommandAst <CommandAst> [<CommonParameters>]
```
---


