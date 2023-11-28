
describe 'Language.YAML' {
    it 'Language.YAML Example 1' {
    .> {
        $yamlContent = @'
PipeScript: |
  {
    @{a='b'}
  }

List:
  - PipeScript: |
      {
        @{a='b';k2='v';k3=@{k='v'}}
      }
  - PipeScript: |
      {
        @(@{a='b'}, @{c='d'})
      }      
  - PipeScript: |
      {
        @{a='b'}, @{c='d'}
      }
'@
        [OutputFile('.\HelloWorld.ps1.yaml')]$yamlContent
    }

    .> .\HelloWorld.ps1.yaml
    }
}

