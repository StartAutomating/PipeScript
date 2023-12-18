
describe 'Template.ForLoop.js' {
    it 'Template.ForLoop.js Example 1' {
        Template.ForLoop.js "let step = 0" "step < 5" "step++" 'console.log("walking east one step")'
    }
    it 'Template.ForLoop.js Example 2' {
        Template.ForLoop.js -Initialization "let step = 0" -Condition "step < 5" -Iterator "step++" -Body '
            console.log("walking east one step")
        '
    }
}

