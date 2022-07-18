This directory and it's subdirectories contain additional language keywords within PipeScript.

Most keywords will be implemented as a Transpiler that tranforms a CommandAST.


|DisplayName       |Synopsis                    |
|------------------|----------------------------|
|[New](New.psx.ps1)|['new' keyword](New.psx.ps1)|




## New Example 1


~~~PowerShell
    .> { new DateTime }
~~~

## New Example 2


~~~PowerShell
    .> { new byte 1 }
~~~

## New Example 3


~~~PowerShell
    .> { new int[] 5 }
~~~

## New Example 4


~~~PowerShell
    .> { new datetime 12/31/1999 }
~~~

## New Example 5


~~~PowerShell
    .> { new @{RandomNumber = Get-Random; A ='b'}}
~~~

## New Example 6


~~~PowerShell
    .> { new Diagnostics.ProcessStartInfo @{FileName='f'} }
~~~

