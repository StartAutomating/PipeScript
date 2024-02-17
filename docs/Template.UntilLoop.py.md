Template.UntilLoop.py
---------------------

### Synopsis
Template for a Python `until` Loop

---

### Description

Template for a `until` loop in Python.

---

### Examples
> EXAMPLE 1

```PowerShell
Template.UntilLoop.py -Condition "True" -Body "print('This happens once')"
```

---

### Parameters
#### **Condition**
The Loop's Condition.
This determines if the loop should continue running.
This defaults to 0 > 1, so that the loop only occurs once

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **InitialCondition**
The Loop's Initial Condition.
Since Python does not have a `do` loop, this needs to be any truthy condition for the loop to run.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Body**
The body of the loop

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|

#### **BodyIndent**
The number of spaces to indent the body.
By default, two.

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |4       |true (ByPropertyName)|

#### **Indent**
The number of spaces to indent all code.
By default, zero

|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |5       |true (ByPropertyName)|

---

### Notes
There is not a proper `do` or `until` loop in Python, so we have to be a little creative.

This will produce a while loop where the `-InitialCondition` should always be true,
and the `-Condition` will be checked at the end of each iteration.

If the `Condition` is true, then the loop will break.

---

### Syntax
```PowerShell
Template.UntilLoop.py [[-Condition] <String>] [[-InitialCondition] <String>] [[-Body] <String>] [[-BodyIndent] <Int32>] [[-Indent] <Int32>] [<CommonParameters>]
```
