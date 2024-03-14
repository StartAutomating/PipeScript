param()

@("<article>"
(ConvertFrom-Markdown -InputObject $this.Content).Html
"</article>") -join ''