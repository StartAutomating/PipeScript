
describe 'Template.HTML.CustomElement' {
    it 'Template.HTML.CustomElement Example 1' {
        Template.HTML.CustomElement -ElementName hello-world -Template "<p>Hello, World!</p>"  -OnConnected "
            console.log('Hello, World!')
        "
        Template.HTML.Element -Name "hello-world"
    }
}

