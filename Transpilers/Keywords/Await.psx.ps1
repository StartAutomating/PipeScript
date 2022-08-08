<#
.SYNOPSIS
    awaits asynchronous operations
.DESCRIPTION
    awaits the result of a task.
.EXAMPLE
    .>PipeScript -ScriptBlock {
        await $Websocket.SendAsync($SendSegment, 'Binary', $true, [Threading.CancellationToken]::new($false))
    }
.EXAMPLE
    .>PipeScript -ScriptBlock {
        $receiveResult = await $Websocket.ReceiveAsync($receiveSegment, [Threading.CancellationToken]::new($false))
    }
#>
[ValidateScript({
    $CommandAst = $_
    $CommandAst.CommandElements -and $CommandAst.CommandElements[0].Value -eq 'await'
})]
param(
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.Language.CommandAST]
$CommandAst
)

process {
    if ($CommandAst.CommandElements.Count -lt 2) {
        Write-Error "await what?"
        return
    }

    if ($CommandAst.CommandElements[0].Value -ne 'await') {
        Write-Error "not await"
        return
    }

    if ($CommandAst.CommandElements[1] -isnot [Management.Automation.Language.InvokeMemberExpressionAst]) {
        Write-Error "await must be followed by an invocation expression"
        return
    }

    # Note: This is one of those cases where version targeting might be handy.
    # older versions of PowerShell (I believe -lt 4.0) will not handle task returns correctly without help.

    [Timespan]$awaitTimeout = '00:00:10'
    [Timespan]$awaitSleep   = 7



    $newScript = @(
        '[DateTime]$awaitTimeout = [DateTime]::Now + "' + "$awaitTimeout" + '"'
        '[TimeSpan]$awaitSleep   = "' + "$awaitSleep" + '"'
        '$awaitTask = ' + "$($commandAst.CommandElements[1].Extent.ToString())"
{
while (!$awaitTask.IsCompleted -and [DateTime]::Now -lt $awaitTimeout) {
    Start-Sleep -Milliseconds $awaitSleep.TotalMilliseconds
}
if ($awaitTask.IsCompleted -and $null -ne $awaitTask.Result) {
    $awaitTask.Result
}
elseif ($awaitTask.IsCompleted -and $awaitTask.Exception) {
    if ($awaitTask.Exception.InnerExceptions) {
        $awaitTask.Exception.InnerExceptions
    } else {
        $awaitTask.Exception
    }
}
}

    ) -join [Environment]::NewLine

    if ($CommandAst.IsAssigned) {
        $newScript = "`$($newScript)"
    }

    [ScriptBlock]::create($newScript)
}
