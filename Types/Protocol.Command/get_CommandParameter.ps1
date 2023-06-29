foreach ($param in $this.Parameters.GetEnumerator()) {
    if ($param.Value.ParameterType -eq [Management.Automation.Language.CommandAST]) {
        return $param.Value
    }
}