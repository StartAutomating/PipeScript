, @(
    foreach ($node in $this.ByType[@(
        [Management.Automation.Language.FunctionDefinitionAst]
        [Management.Automation.Language.TypeDefinitionAst]
    )]) {
        $node
    }
)
