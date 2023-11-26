Signal.Out
----------

### Synopsis
Outputs a Signal

---

### Description

Outputs a Signal with whatever name, arguments, input, and command.

A signal is a PowerShell event.

---

### Examples
> EXAMPLE 1

```PowerShell
Out-Signal "hello"
```
> EXAMPLE 2

```PowerShell
Set-Alias MySignal Out-Signal
MySignal
```

---

### Syntax
```PowerShell
Signal.Out [<CommonParameters>]
```
