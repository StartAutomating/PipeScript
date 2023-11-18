System.Management.Automation.Language.VariableExpressionAst.ConvertFromAST()
----------------------------------------------------------------------------

### Synopsis
Converts a VariablExpressionAST to an object

---

### Description

Converts a VariablExpressionAST to an object, if possible.

Most variables we will not know the value of until we have run.

The current exceptions to the rule are:  $true, $false, and $null

---
