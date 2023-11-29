Language.YAML
-------------

### Synopsis
Yaml PipeScript Language Definition.

---

### Description

Allows PipeScript to generate Yaml.

Because Yaml does not support comment blocks, PipeScript can be written inline inside of specialized Yaml string.

PipeScript can be included in a multiline Yaml string with the Key PipeScript and a Value surrounded by {}

---

### Examples
> EXAMPLE 1

```PowerShell
{
    $yamlContent = @'
PipeScript: |
{
@{a='b'}
}
List:
- PipeScript: |
  {
    @{a='b';k2='v';k3=@{k='v'}}
  }
- PipeScript: |
  {
    @(@{a='b'}, @{c='d'})
  }      
- PipeScript: |
  {
    @{a='b'}, @{c='d'}
  }
'@
    [OutputFile('.\HelloWorld.ps1.yaml')]$yamlContent
}

.> .\HelloWorld.ps1.yaml
```

---

### Syntax
```PowerShell
Language.YAML [<CommonParameters>]
```
