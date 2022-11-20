# and extract the difference between the parent and the start of the block
$offsetDifference = $this.Extent.StartOffset - $this.Parent.Extent.StartOffset
# (this is where the header and help reside)
# try to strip off leading braces and whitespace
$this.Parent.Extent.ToString().Substring(0, $offsetDifference) -replace '^[\r\n\s]{0,}\{'