
describe 'Template.PipeScript.Dot' {
    it 'Template.PipeScript.Dot Example 1' {
        .> {
            [DateTime]::now | .Month .Day .Year
        }
    }
    it 'Template.PipeScript.Dot Example 2' {
        .> {
            "abc", "123", "abc123" | .Length
        }
    }
    it 'Template.PipeScript.Dot Example 3' {
        .> { 1.99 | .ToString 'C' [CultureInfo]'gb-gb' }
    }
    it 'Template.PipeScript.Dot Example 4' {
        .> { 1.99 | .ToString('C') }
    }
    it 'Template.PipeScript.Dot Example 5' {
        .> { 1..5 | .Number { $_ } .Even { -not ($_ % 2) } .Odd { ($_ % 2) -as [bool]} }
    }
    it 'Template.PipeScript.Dot Example 6' {
        .> { .ID { Get-Random } .Count { 0 } .Total { 10 }}
    }
    it 'Template.PipeScript.Dot Example 7' {
        .> {
            # Declare a new object
            .Property = "ConstantValue" .Numbers = 1..100 .Double = {
                param($n)
                $n * 2
            } .EvenNumbers = {
                $this.Numbers | Where-Object { -not ($_ % 2)}
            } .OddNumbers = {
                $this.Numbers | Where-Object { $_ % 2}
            }
        }
    }
}

