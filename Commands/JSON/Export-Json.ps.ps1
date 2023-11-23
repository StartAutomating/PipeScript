function Export-Json {
    <#
    .SYNOPSIS
        Exports content as JSON
    .DESCRIPTION
        Exports content as JSON
    .EXAMPLE
        1..10 | Export-Json -Path .\Test.json
    .PARAMETER Path
        Specifies the path to the file where the JSON representation of the object will be stored.
    .PARAMETER LiteralPath
        Specifies the path to the file where the JSON representation of the object will be stored.
        Unlike Path, the value of the LiteralPath parameter is used exactly as it's typed.
        No characters are interpreted as wildcards.
        If the path includes escape characters, enclose it in single quotation marks.
        Single quotation marks tell PowerShell not to interpret any characters as escape sequences.
    .PARAMETER Encoding
        Specifies the type of encoding for the target file. The default value is `utf8NoBOM`.
        The acceptable values for this parameter are as follows:
        * `ascii`: Uses the encoding for the ASCII (7-bit) character set.
        * `bigendianunicode`: Encodes in UTF-16 format using the big-endian byte order.
        * `bigendianutf32`: Encodes in UTF-32 format using the big-endian byte order.
        * `oem`: Uses the default encoding for MS-DOS and console programs.
        * `unicode`: Encodes in UTF-16 format using the little-endian byte order.
        * `utf7`: Encodes in UTF-7 format.
        * `utf8`: Encodes in UTF-8 format.
        * `utf8BOM`: Encodes in UTF-8 format with Byte Order Mark (BOM)
        * `utf8NoBOM`: Encodes in UTF-8 format without Byte Order Mark (BOM)
        * `utf32`: Encodes in UTF-32 format.

        Beginning with PowerShell 6.2, the Encoding parameter also allows numeric IDs of registered code pages (like `-Encoding 1251`) or string names of registered code pages (like `-Encoding "windows-1251"`). For more information, see the .NET documentation for Encoding.CodePage (/dotnet/api/system.text.encoding.codepage?view=netcore-2.2).
        > [!NOTE] > UTF-7 * is no longer recommended to use. As of PowerShell 7.1, a warning is written if you > specify `utf7` for the Encoding parameter.
    .PARAMETER Force
        Forces the command to run without asking for user confirmation.
        Causes the cmdlet to clear the read-only attribute of the output file if necessary.
        The cmdlet will attempt to reset the read-only attribute when the command completes.
    .PARAMETER InputObject
        Specifies the object to be converted.
        Enter a variable that contains the objects, or type a command or expression that gets the objects.
        You can also pipe objects to `Export-Json`.
    .PARAMETER NoClobber
        Indicates that the cmdlet doesn't overwrite the contents of an existing file.
        By default, if a file exists in the specified path, `Export-Clixml` overwrites the file without warning.
    .PARAMETER Confirm
        Prompts you for confirmation before running the cmdlet.
    .PARAMETER WhatIf
        Shows what would happen if the cmdlet runs. The cmdlet isn't run.
    #>
    [Inherit('Export-Clixml', Abstract)]
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The delimiter between objects.
    # If a delimiter is provided, it will be placed between each JSON object.
    [string]
    $Delimiter
    )
   
    $ConvertToJsonParameters = [Ordered]@{}
    
    if ($depth) { $ConvertToJsonParameters['Depth'] = $depth }
    $inputObjects = @($input)
    if ($inputObjects.Length -eq 1) {
        $ConvertToJsonParameters.InputObject = $inputObjects[0]
    } else {
        $ConvertToJsonParameters.InputObject = $inputObjects
    }

    $FileSplat = [Ordered]@{}
    
    if ($path) { $FileSplat['Path'] = $path;}
    elseif ($literalPath) { $FileSplat['LiteralPath'] = $literalPath; }
    
    if ((-not $Force) -and $NoClobber) {
        if ((Test-Path @fileSplat) -and -not $Force) {
            Write-Error "$($Path; $literalPath) already exists, use -Force to overwrite."
            return
        }
    }
    
    if ($encoding) {
        $fileSplat['Encoding'] = $encoding
    }

    if ($psCmdlet.ShouldProcess("$FileSplat")) {
        if ($Delimiter) {
            @(foreach ($inObj in $inputObjects) {
                $ConvertToJsonParameters.InputObject = $inObj
                ConvertTo-Json @ConvertToJsonParameters
            }) -join $Delimiter | Set-Content @FileSplat
        } else {
            ConvertTo-Json @ConvertToJsonParameters | Set-Content @FileSplat
        }            
    }    
}