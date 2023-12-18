
describe 'Template.Method.js' {
    it 'Template.Method.js Example 1' {
        Template.Method.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    }
    it 'Template.Method.js Example 2' {
        "doSomething()" |Template.Method.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    }
}

