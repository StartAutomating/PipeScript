
describe 'Template.InvokeMethod.js' {
    it 'Template.InvokeMethod.js Example 1' {
        Template.InvokeMethod.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    }
    it 'Template.InvokeMethod.js Example 2' {
        "doSomething()" |Template.InvokeMethod.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    }
}

