#1. Implicit Interpretation

# Implicit Interpretation is a part of PipeScript that allows you to implicitly run anything with an interpreter

# This means any language can be seamlessly run from PipeScript

# Let's start simple (with JavaScript)
"console.log('All Your Base Belong To Us')" > .\Message.js

# Now let's run it.
.\Message.js

# Let's try another language (Python)
"print('Run anything with PipeScript')" > .\Message.py

# And let's run that:
.\Message.py

# Why stop there, let's Go!
@"
package main

import "fmt"

func main() {
    fmt.Println("Go is also fair game")
}
"@ > Message.go

.\Message.go

# Is that all?  Nope.

# $psInterpreter(s) gives us all interpretable languages
$PSInterpreter

# How many interpreters are there, currently?
$PSInterpreters.Count

# $psLanguage(s) gives us all languages.
$psLanguage

# How many languages can PipeScript talk to?
$PSLanguages.Count