
describe 'protocol.JSONSchema' {
    it 'protocol.JSONSchema Example 1' {
        jsonschema https://aka.ms/terminal-profiles-schema#/$defs/Profile
    }
    it 'protocol.JSONSchema Example 2' {
        {
            [JSONSchema(SchemaURI='https://aka.ms/terminal-profiles-schema#/$defs/Profile')]
            param()
        }.Transpile()
    }
}

