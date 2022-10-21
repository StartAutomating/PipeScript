if ($this.Parent -isnot [Management.Automation.Language.PipelineAst]) { return $false }
$this.Parent.PipelineElements.IndexOf($this) -lt ($this.Parent.PipelineElements.Count - 1)
