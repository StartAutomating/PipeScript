Out-Parser
----------

### Synopsis
Outputs Parser to PowerShell

---

### Description

Outputs Parser as PowerShell Objects.

Parser Output can be provided by any number of Commands to Out-Parser.

Commands use two attributes to indicate if they should be run:

~~~PowerShell
[Management.Automation.Cmdlet("Out","Parser")] # This signals that this is an Command for Out-Parser
[ValidatePattern("RegularExpression")]      # This is run on $ParserCommand to determine if the Command should run.
~~~

---

### Related Links
* [Invoke-Parser](Invoke-Parser.md)

---

### Parameters
#### **ParserOutputLine**
One or more output lines to parse.

|Type        |Required|Position|PipelineInput |Aliases          |
|------------|--------|--------|--------------|-----------------|
|`[String[]]`|false   |named   |true (ByValue)|ParserOutputLines|

#### **CommandLine**
The command line that describes what is being parsed.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **ErrorPattern**
The pattern used to identify lines with errors

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **WarningPattern**
The pattern used to identify lines with warnings

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **TimeStamp**
The timestamp.   This can be used for tracking.  Defaults to [DateTime]::Now

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[DateTime]`|false   |named   |false        |

---

### Notes
Out-Parser will generate two events upon completion.  They will have the source identifiers of "Out-Parser" and "Out-Parser $ParserArgument"

---

### Syntax
```PowerShell
Out-Parser [-ParserOutputLine <String[]>] [-CommandLine <String>] [-ErrorPattern <String>] [-WarningPattern <String>] [-TimeStamp <DateTime>] [<CommonParameters>]
```
