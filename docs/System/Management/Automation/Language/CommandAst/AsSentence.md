System.Management.Automation.Language.CommandAst.AsSentence()
-------------------------------------------------------------

### Synopsis
Maps Natural Language Syntax to PowerShell Parameters

---

### Description

Maps a statement in natural language syntax to a set of PowerShell parameters.

All parameters will be collected.

For the purposes of natural language processing ValueFromPipeline will be ignored.

The order the parameters is declared takes precedence over Position attributes.

---

### Notes
Each potential command can be thought of as a simple sentence with (mostly) natural syntax

command <parametername> ...<parameterargument> (etc)
    
either more natural or PowerShell syntax should be allowed, for example:

~~~PowerShell
all functions can Quack {
    "quack"
}
~~~

would map to the command all and the parameters -Function and -Can (with the arguments Quack and {"quack"})

Assuming -Functions was a `[switch]` or an alias to a `[switch]`, it will match that `[switch]` and only that switch.

If -Functions was not a `[switch]`, it will match values from that point.

If the parameter type is not a list or PSObject, only the next parameter will be matched.

If the parameter type *is* a list or an PSObject, 
or ValueFromRemainingArguments is present and no named parameters were found,
then all remaining arguments will be matched until the next named parameter is found.

_Aliasing is important_ when working with a given parameter.
The alias, _not_ the parameter name, will be what is mapped in .Parameters.

---
