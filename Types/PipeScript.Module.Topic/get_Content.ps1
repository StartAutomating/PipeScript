<#
.SYNOPSIS
    Gets a topic's content.
.DESCRIPTION
    Gets a topic's content.

    The content is cached for performance reasons.
.EXAMPLE
    $PipeScript.Topics.AllTopics.Content # This will be a bunch of markdown content
#>
param()
if (-not $this.'.CachedContent') {
    $this | Add-Member NoteProperty '.CachedContent' ([IO.File]::ReadAllText($this.Fullname)) -Force
}
$this.'.CachedContent'
