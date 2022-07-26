if ($this.Parent -isnot [Management.Automation.Language.PipelineAst]) { return $null }
$this.Parent.PipelineElements.Count


