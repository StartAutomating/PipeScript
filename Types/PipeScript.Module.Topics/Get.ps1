<#
.SYNOPSIS
    Gets a topic.
.DESCRIPTION
    Gets a topic by name.
#>
param(
# The name of a topic
[string]
$TopicName
)

$TopicName = $TopicName -replace '[_-]', ' '
foreach ($topic in $this.AllTopics) {
    if ($topic.TopicName -eq $TopicName) {
        return $topic
    }
}

