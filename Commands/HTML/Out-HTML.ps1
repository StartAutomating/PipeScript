function Out-HTML {
    <#
    .Synopsis
        Produces HTML output from the PowerShell pipeline.
    .Description
        Produces HTML output from the PowerShell pipeline, doing the best possible to obey the formatting rules in PowerShell.
    .Example
        Get-Process -id $pid | Out-HTML
    #>
    [OutputType([string])]
    [Alias('text.html.out')]
    [CmdletBinding(DefaultParameterSetName='DefaultFormatter')]
    param(
    # The input object
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,
    
    # The desired identifier for the output.
    [string]
    $Id,
    
    # The CSS class for the output.  This will be inferred from the .pstypenames 
    [string]
    $CssClass,        
    
    # A CSS Style 
    [Collections.IDictionary]
    $Style,        
    
    # If set, will enclose the output in a div with an itemscope and itemtype attribute
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]$ItemType,
    
    # If more than one view is available, this view will be used
    [string]$ViewName)
        
    begin {
        filter ToDataAttribute {
            if ($_ -isnot [Management.Automation.PSPropertyInfo]) { return }
            $propValue = $_.Value
            if (-not $propValue.GetType) { return }
            $propType = $propValue.GetType()            
            

            $dataAttributeValue = 
                if ($propType.IsPrimitive) {
                    "$propValue"
                }
                elseif ($propType -eq [string]) {
                    "'$([Security.SecurityElement]::Escape($propValue))'"
                }
                elseif ($propType -eq [DateTime]) {
                    "'$($propValue.ToString('o'))'"
                }
                elseif ($propType -eq [TimeSpan]) {
                    "$propValue"
                }

            if ($null -ne $dataAttributeValue) {
                $decamelCase = [Regex]::new('(?<=\p{Ll})(?=\p{Lu})')

                $dataAttributeName = ($_.Name -replace $decamelCase, '-' -replace "\p{P}", '-').ToLower()
                return "data-$dataAttributeName=$dataAttributeValue"
            }
            
        }

        # We start off by declaring a big Regex to match ANSI Styles.
        # (thanks [Irregular](https://github.com/StartAutomating/Irregular) ! )
        ${?<ANSI_Style>} = [Regex]::new(@'
        (?<ANSI_Style>
        (?>
          (?<ANSI_Reset>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?<Reset>0m)                                                                           # 0m indicates reset
        
        )
          |
          (?<ANSI_Bold>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<BoldStart>1m)  |
          (?<BoldEnd>22m))
        )
          |
          (?<ANSI_Blink>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?>
          (?<BlinkStart>(?<BlinkSlow>5m)                                                       # 5m starts a slow blink
            |
            (?<BlinkFast>6m)                                                                   # 6m starts a slow blink
        ))  |
          (?<BlinkEnd>25m)                                                                     # 25m stops blinks
        )
        )
          |
          (?<ANSI_Faint>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<FaintStart>2m)                                                                    # 2m starts faint
          |
          (?<FaintEnd>22m)                                                                     # 22m stops faint
        )
        )
          |
          (?<ANSI_Italic>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<ItalicStart>3m)                                                                   # 3m starts italic
          |
          (?<ItalicEnd>23m)                                                                    # 23m stops italic
        )
        )
          |
          (?<ANSI_Invert>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<InvertStart>7m)                                                                   # 7m starts invert
          |
          (?<InvertEnd>27m)                                                                    # 27m stops invert
        )
        )
          |
          (?<ANSI_Hide>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<HideStart>8m)                                                                     # 8m starts hide
          |
          (?<HideEnd>28m)                                                                      # 28m stops hide
        )
        )
          |
          (?<ANSI_Strikethrough>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<StrikethroughStart>9m)                                                            # 9m starts Strikethrough
          |
          (?<StrikethroughEnd>29m)                                                             # 29m stops Strikethrough
        )
        )
          |
          (?<ANSI_Underline>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<UnderlineStart>4m)                                                                # 4m starts underline
          |
          (?<DoubleUnderlineStart>21m)                                                         # 21m start a double underline
          |
          (?<UnderlineEnd>24m)                                                                 # 24m stops underline
        )
        )
          |
          (?<ANSI_24BitColor>
        (?-i)\e                                                                                # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<IsForegroundColor>38)  |
          (?<IsBackgroundColor>48)  |
          (?<IsUnderlineColor>58));2;(?<Color>(?<Red>(?>[0-2][0-5][0-5]|[0-1]\d\d|\d{1,2}))    # Red is the first 0-255 value
        ;(?<Green>(?>[0-2][0-5][0-5]|[0-1]\d\d|\d{1,2}))                                       # Green is the second 0-255 value
        ;(?<Blue>(?>[0-2][0-5][0-5]|[0-1]\d\d|\d{1,2}))                                        # Blue is the third 0-255 value
        m)
        )
          |
          (?<ANSI_8BitColor>
        (?-i)\e                                                                                # An Escape
        \[                                                                                     # Followed by a bracket
        (?>
          (?<IsForegroundColor>38)  |
          (?<IsBackgroundColor>48)  |
          (?<IsUnderlineColor>58));5;(?<Color>(?>
          (?<StandardColor>[0-7])                                                              # 0 -7 are standard colors
        m  |
          (?<BrightColor>(?>[8-9]|1[0-5]))                                                     # 8-15 are bright colors
        m  |
          (?<CubeColor>(?>[0-2][0-3][0-1]|[0-1]\d\d|\d{1,2}))                                  # 16-231  are cubed colors
        m  |
          (?<GrayscaleColor>(?>[0-2][0-5][0-5]|[0-1]\d\d|\d{1,2}))                             # 232-255 are grayscales
        m))
        )
          |
          (?<ANSI_4BitColor>
        \e                                                                                     # An Escape
        \[                                                                                     # Followed by a bracket
        (?<Color>(?>
          (?<IsBright>1)?\;{0,1}                                                               # A 1 and a semicolon indicate a bright color
        (?<IsForegroundColor>3)                                                                # A number that starts with 3 indicates foreground color
          |
          (?<IsBright>(?<IsForegroundColor>9))                                                 # OR it could be a less common bright foreground color, which starts with 9
          |
          (?<IsBright>1)?\;{0,1}                                                               # A 1 and a semicolon indicate a bright color
        (?<IsBackgroundColor>4)                                                                # A number that starts with 3 indicates foreground color
          |
          (?<IsBright>(?<IsBackgroundColor>10))                                                # OR it could be a less common bright foreground color, which starts with 9
        )(?<ColorNumber>[0-7])                                                                 # The color number will be between 0 and 7
        (?:\;{0,1}(?<IsBright>1)?)?                                                            # Brightness can also come after a color
        m)
        )
          |
          (?<ANSI_DefaultColor>
        (?-i)\e                                                                                # An Escape
        \[                                                                                     # Followed by a bracket
        (?<Color>(?>
          (?<DefaultForeground>39)                                                             # 39 Represents the default foreground color
        m  |
          (?<DefaultForeground>49)                                                             # 49 Represents the default background color
        m))
        )
        )
        )
'@, 'IgnoreCase,IgnorePatternWhitespace', '00:00:05')



        if (-not $script:QuickRandom) {
            $script:QuickRandom = [Random]::new()
        }
        
        $tablesForTypeNames = @{}
        $tableCalculatedProperties = @{}
        $tableColumnAlignment = @{}
        $tableFormatString = @{}
        if (-not $Script:CachedformatData -or $DebugPreference -ne 'SilentlyContinue') {
            $Script:CachedformatData = @{}
        }
        $stopLookingFor = @{}
        $CachedControls = @{}        
        $htmlOut = [Text.StringBuilder]::new()
        $typeNamesEncountered = [Collections.ArrayList]::new()
        if (-not $script:LoadedFormatFiles -or $DebugPreference -ne 'SilentlyContinue') {
            $script:loadedFormatFiles = @(Get-ChildItem $psHome -Filter *.format.ps1xml | Select-Object -ExpandProperty Fullname) + 
                @(Get-Module | Select-Object -ExpandProperty ExportedFormatFiles)
            
            $script:loadedViews = $loadedFormatFiles | Select-Xml -Path {$_ } "//View"

            $script:loadedSelectionSets = $loadedFormatFiles | 
                Select-Xml -Path { $_ } "//SelectionSet" |
                . {
                    begin {
                        $selectionSetTable = @{}
                    }
                    
                    process {
                        $n = $_
                        foreach ($t in $_.Node.Types) {
                            foreach ($tn in $t.TypeName) {
                                $selectionSetTable[$tn]=$n.Node.Name
                            }
                        }                    
                    }
                    
                    end {
                        $selectionSetTable
                    }
                }
        }


        $useRandomSalt = $false

        # Keep track of type names and accumulate input for custom formatters: this lets us pipe and support custom action headers, as well as pipelining to custom formatters
        $LastTypeName = ''
        $AccumulatedInput = [Collections.ArrayList]::new()
        
        #region Handle Custom Formatter
        $RunCustomFormatter = {
            param($in)
            
            if ($formatData -is [ScriptBlock] -or $formatData -is [IO.FileInfo]) {
                $_ = $in
                $null = $htmlOut.Append("$(. $Script:CachedformatData[$typeName])")
            } elseif ($formatData -is [string]) {
                # If it's a string, just set $_ and expand the string, which allows subexpressions inside of HTML
                
                foreach ($prop in $in.psobject.properties) {
                    $ExecutionContext.SessionState.PSVariable.Set($prop.Name, $prop.Value)
                    #Set-Variable $prop.Name -Value $prop.Value -ErrorAction SilentlyContinue
                }
                $_ = $in
                $ExecutionContext.SessionState.InvokeCommand.ExpandString($Script:CachedformatData[$typeName])
            } elseif ($formatData -is [Xml.XmlElement] -and $formatData.CustomControl) {
                # SelectionSet or Custom Formatting Action
                
                $frame = $Script:CachedformatData[$typeName].CustomControl.customentries.customentry.customitem.frame
                foreach ($frameItem in $frame) {
                    $item  =$frameItem.customItem
                    foreach ($expressionItem in $item) {
                        if (-not $expressionItem) { continue } 
                        $expressionItem | 
                            Select-Xml "ExpressionBinding|NewLine" |
                            & {
                                begin {
                                    if ($itemType) {
                                        $null = $htmlOut.Append("<div itemscope='' itemtype='$($itemType -join "','")'>")
                                    }
                                } 
                                process {
                                    if ($_.Node.Name -eq 'ExpressionBinding') {
                                        $finalExpr =($_.Node.SelectNodes("ScriptBlock") | 
                                            ForEach-Object {
                                                $_."#text"
                                            }) -ireplace "Microsoft.PowerShell.Utility\Write-Host", "Write-Host"
                                        $_ = $in
                                        $null = $htmlOut.Append("$($global:ExecutionContext.InvokeCommand.InvokeScript($finalExpr))")
                                    } elseif ($_.Node.Name -eq 'Newline') {
                                        $null = $htmlOut.Append("<br/>")
                                    }
                                }
                            
                                end{
                                    if ($itemType) {
                                        $null = $htmlOut.Append("</div>")
                                    }
                                }
                            }|                                 
                            Where-Object { $_.Node.Name -eq 'ExpressionBinding' }
                        if (-not $expressionBinding.firstChild.ItemSelectionCondition) {
                                                                
                        }
                    }
                }                                
                # Lets see what to do here
            } else {                                
                if (-not $CachedControls[$typeName]) {
                    $control = 
                        if ($formatData.TableControl) {
                            $formatData.TableControl
                        } else {
                            foreach ($_ in $formatData.FormatViewDefinition) {
                                if (-not $_) { continue }
                                $result = foreach ($ctrl in $_.Control) {
                                    if ($ctrl.Headers -or $ctrl.Rows) { 
                                        $ctrl
                                        break
                                    }
                                }
                                if ($result) { 
                                    $result
                                    break 
                                }
                            }
                        }
                    
                    $CachedControls[$typeName]= $control
                    if (-not $cachedControls[$TypeName]) {
                        $control = foreach ($_ in $formatData.CustomControl) {
                            if (-not $_) { continue }
                        }
                        $CachedControls[$typeName]= $control
                    }
                }
                $control = $CachedControls[$typeName]
                             
                if (-not ($tablesForTypeNames[$typeName])) {
                    $tableCalculatedProperties[$typeName] = @{}
                    $tableColumnAlignment[$typeName] = @{}
                    $tableFormatString[$typeName] = @{}
                    $tableID = 
                        if (-not $psBoundParameters.id) { 
                            $id = "TableFor$($TypeName.Replace('/', '_Slash_').Replace('.', "_").Replace(" ", '_'))$($script:QuickRandom.Next())" 
                        } else {
                            $psBoundParameters.id
                        }

                        
                    $tableHeader = [Text.StringBuilder]::new()
                    if (-not $classChunk) { $classChunk = "class='$($TypeName.Replace('/', '_Slash_').Replace('.', "_").Replace(" ", '_').Replace("'","''"))'"}
                    $null = $tableHeader.Append("
<table id='${id}${randomSalt}' $classChunk $cssstyleChunk>
    <thead>
        <tr>")
                    $labels = [Collections.ArrayList]::new()
                    if ($control.TableRowEntries) {
                        # Selection set
                        $n =0 
                        $columns =
                            @(foreach ($col in $control.TableRowEntries.TableRowEntry.TableColumnItems.TableColumnItem) {
                                $label = if ($control.TableHeaders.TableColumnHeader[$n].Label) {
                                    $control.TableHeaders.TableColumnHeader[$n].Label
                                } else {
                                    $col.PropertyName
                                }                                
                                if ($control.TableHeaders.TableColumnHeader[$n].Alignment -ne 'Undefined') {
                                    $tableColumnAlignment[$typeName].$label = "$($control.TableHeaders.TableColumnHeader[$n].Alignment)".ToLower()
                                }
                                if ($col.PropertyName) {
                                    $prop = $col.PropertyName
                                    $tableCalculatedProperties[$typeName][$label] = [ScriptBlock]::Create("`$in.'$prop'")
                                } elseif ($col.ScriptBlock) {
                                    $tableCalculatedProperties[$typeName][$label] = [ScriptBlock]::Create($col.ScriptBlock)
                                }

                                if ($col.FormatString) {
                                    $tableFormatString[$typeName].$label = 
                                        if ($col.FormatString -like '{*:*}') {
                                            $col.FormatString
                                        } else {
                                            "{0:$($col.FormatString)}"
                                        }
                                }
                                $label
                                $n++
                            })
                    } else {
                        # Direct table view                        
                        $n =0 
                        $columns = 
                            @(foreach ($col in $control.Rows[0].Columns) {
                                $label =
                                    if ($control.Headers[$n].Label) {
                                        $control.Headers[$n].Label
                                    } else {
                                        $col.DisplayEntry.Value
                                    }
                                if ($col.DisplayEntry.ValueType -eq 'Property') {
                                    $prop = $col.DisplayEntry.Value
                                    $tableCalculatedProperties[$typeName][$label] = [ScriptBlock]::Create("`$in.'$prop'")
                                } elseif ($col.DisplayEntry.ValueType -eq 'ScriptBlock') {
                                    $tableCalculatedProperties[$typeName][$label] = [ScriptBlock]::Create($col.DisplayEntry.Value)
                                }
                                if ($control.Headers[$n].Alignment -ne 'Undefined') {
                                    $tableColumnAlignment[$typeName].$label = "$($control.Headers[$n].Alignment)".ToLower()
                                }
                                if ($col.FormatString) {
                                    $tableFormatString[$typeName].$label = 
                                        if ($col.FormatString -like '{*:*}') {
                                            $col.FormatString
                                        } else {
                                            "{0:$($col.FormatString)}"
                                        } 
                                }
                                $n++
                                $label
                            })
                    }
                                                                                                    
                    $headerCount = $columns.Count
                    foreach ($_ in $columns) {
                        
                        $null = $tableHeader.Append("
            <th style='$(if ($tableColumnAlignment[$typeName][$_]) { 'text-align:' + $tableColumnAlignment[$typeName][$_]})'>$_</th>")
                    }
                    $labels.AddRange($columns)
                        
                    
                    $null = $tableHeader.Append("
        </tr>
    </thead>
    <tbody>")
                    $tablesForTypeNames[$typeName] = $tableHeader
                    $null = $typeNamesEncountered.Add($typeName)
                }
                
            $currentTable = $tablesForTypeNames[$typeName]
            
            $rowDataAttributes = @(
                foreach ($label in $labels) {
                    $in.psobject.properties[$label]
                }
            ) | ToDataAttribute

            $rowDataString = if ($rowDataAttributes) {
                ' ' + ($rowDataAttributes -join ' ')
            } else {''}

            # Add a row
            $null = $currentTable.Append("
        <tr$rowDataString>") 
                foreach ($label in $labels) {
                    $value = " "
                    if ($tableCalculatedProperties[$typeName][$label]) {
                        $_ = $in
                        $value = . $tableCalculatedProperties[$typeName][$label]                      
                    }
                    if ($tableFormatString[$typeName][$label]) {
                        $value = $tableFormatString[$typeName][$label] -f $value
                    }
                    $value = "$($value -join ([Environment]::NewLine))".Replace([Environment]::NewLine, '<BR/> ')
                    $rowStyle = @(
                        if ($tableColumnAlignment[$typeName][$label]) { 'text-align:' + $tableColumnAlignment[$typeName][$label]}
                    ) -join ';'
                    if ($rowStyle) {
                        $rowStyle = " style='$rowStyle'"
                    }
                    $null = $currentTable.Append("
            <td${rowStyle}>$($value.Replace('&', '&amp;'))</td>")
                }
                $null = $currentTable.Append("
        </tr>")     
            }                                
        }
        #endregion Handle Custom Formatter
    }
    
    process {   
        # In case nulls come in, quietly return
        if ($null -eq $InputObject ) {  return }

        $randomSalt = 
            if ($useRandomSalt) {
                "_$($script:QuickRandom.Next())"
            } else {
                ""
            }
        
        $classChunk = 
            if ($cssClass) { "class='$($cssClass -join ' ')'" }
            else { '' }

        $cssStyleChunk = 
            if ($psBoundParameters.Style) {
                @(
                    "style='"
                    @(foreach ($kv in $Style.GetEnumerator()) {
                        @($kv.Key
                        ':'
                        $kv.Value) -join ''
                    }) -join ';'
                    "'"
                ) -join ''                 
            } else {
                ""
            }
        
        if ($inputObject -is [string]) {
            # Strings are often simply passed thru, but could potentially be escaped.
            $trimmedString = $inputObject.TrimStart([Environment]::NewLine).TrimEnd([Environment]::NewLine).TrimStart().TrimEnd()            
            # If the string looks @ all like markup or HTML, pass it thru
            
            if ($inputObject -match "^\s{0,}\<" -and $inputObject -match "\>\s{0,}$") {                
                if ($escape) { 
                    $null = $htmlOut.Append("
$([Web.HttpUtility]::HtmlEncode($inputObject).Replace([Environment]::NewLine, '<BR/>').Replace('`n', '<BR/>').Replace(' ', '&nbsp;'))
")
                } else {
                    $null = $htmlOut.Append("$inputObject")
                } 
            } else {
                $null= $htmlOut.Append("$([Web.HttpUtility]::HtmlEncode($inputObject))")
            }            
        } elseif ([Double], [int], [uint32], [long], [byte] -contains $inputObject.GetType()) {
            # If it's a number, simply print it out
            $null= $htmlOut.Append("
<span class='Number' style='font-size:1.25em'>
$InputObject
</span>
")            
        } elseif ($inputObject -is [xml] -and $inputObject.pstypenames -eq 'System.Xml.XmlDocument') {
            
            # If it's an XML document and the typenames haven't been cleared, then render the XML inside of a pre tag
            $null= $htmlOut.Append(@"
$($inputObject.OuterXml)
"@)
        } elseif ([DateTime] -eq $inputObject.GetType()) {
            # If it's a date, out Out-String to print the long format            
            $null= $htmlOut.Append("
<span class='DateTime'>
$($inputObject | Out-String)
</span>
")                    
        } elseif ($inputObject -is [Collections.IDictionary]) {
            # If it's a hashtable or a dictionary, try to recreate the hashtable as an object.
            $null = $psBoundParameters.Remove('InputObject')            
            $inputObjecttypeName = ""
            $inputObjectcopy = @{} + $inputObject
            if ($inputObjectcopy.PSTypeName) {
                $inputObjecttypeName = $inputObject.PSTypeName
                $inputObjectcopy.Remove('PSTypeName')
            }
            
            foreach ($kv in @($inputObjectcopy.GetEnumerator())) {
                if ($kv.Value -is [Collections.IDictionary]) {                    
                    $inputObjectcopy[$kv.Key] = Out-HTML -InputObject $kv.Value
                }
            }
            
            if ($inputObjectCopy) {
            
            
                [PSCustomObject]$inputObjectcopy | 
                    & { process {                
                        $_.pstypenames.clear()
                        foreach ($inTypeName in $inputObjectTypeName) {
                            if (-not $inTypeName) {continue }
                            
                            $null = $_.pstypenames.add($inTypeName)
                        }
                        if (-not $_.pstypenames) {
                            $_.pstypenames.add('PropertyBag')
                        }
                        $psBoundparameters.ItemType = $inputObjectTypeName
                        $_
                    } } | Out-HTML @psboundParameters
            }
        } else {
            $matchingTypeName = $null
            #region Match TypeName to Formatter
            foreach ($typeName in $inputObject.psObject.typenames) {             
                
                if ($matchingTypeName) {continue } # If we've already found a match, don't bother
                
                # Make sure to fix deserialized types, just like the real PowerShell formatting engine
                $typeName = if ($typename.StartsWith('Deserialized.')) {
                    $typename.Substring('Deserialized.'.Length)
                } else {
                    $typename
                }
                # Make sure we haven't given up already
                if ($stopLookingFor[$typeName]) { continue }
                # If we have a cached formatter, return that                  
                if ($Script:CachedformatData[$typeName] ) { 
                    $matchingTypeName = $typename
                    break
                }

                
                $selectionSetName = $loadedSelectionSets[$typeName]
                                                
                
                # If we don't have a cached formatter, see if we can find one
                if (-not $Script:CachedformatData[$typeName]) {                                                                                   
                    if (-not $Script:CachedformatData[$typeName]) {
                        $Script:CachedformatData[$typeName] = try { Get-FormatData -TypeName $typeName -ErrorAction Ignore } catch {$null}
                    }
                    
                        
                    # Still nothing?  Unfortunately, Get-FormatData isn't so great at finding custom actions (or selection sets), so look for those
                    if (-not $Script:CachedformatData[$TypeName]) {                
                        # This covers custom action
                        $Script:CachedformatData[$typeName] = 
                            foreach ($view in $loadedViews) {
                                 
                                if ($view.Node.ViewselectedBy.TypeName -eq $TypeName) { 
                                    if ($ViewName -and $view.Node.Name -eq $ViewName) {
                                        $view.Node
                                        break

                                    } else {
                                        $view.Node
                                        break

                                    }
                                } elseif ($selectionSetName -and $view.Node.ViewSelectedBy.SelectionSetName -eq $selectionSetName) {
                                    $view.Node
                                    break
                                }
                            }
                                
                        if ($Script:CachedformatData[$typeName]) {
                                                       
                            $matchingTypeName = $typeName
                        } else {                           
                        
                            # At this point, we're reasonably certain that no formatter exists, so
                            # Make sure we stop looking for the typename, or else this expensive check is repeated for each item                                                        
                            if (-not $Script:CachedformatData[$typeName]) {                            
                                $stopLookingFor[$typeName]  = $true
                            }
                        }
                    } else {
                        $matchingTypeName = $typeName
                        break
                    }                                        
                }
            }

            $TypeName = $MatchingtypeName                        
            
            
            #endregion Match TypeName to Formatter
            
            if ($MatchingtypeName) {
                if ($typeName -ne $LastTypeName) {
                    if ($AccumulatedInput.Count) {
                        $formatData = $Script:CachedformatData[$LastTypeName]
                        $cssSafeTypeName =$LastTypeName.Replace('.','').Replace('#','')
                    
                        if ($formatData.PipelineAware) {
                            if ($formatData -is [ScriptBlock] -or $formatData -is [IO.FileInfo]) {
                                $null = $htmlOut.Append("$($AccumulatedInput | . $Script:CachedformatData[$typeName])")
                            }                            
                        } else {
                            foreach ($ai in $AccumulatedInput) {
                                . $RunCustomFormatter $ai
                            }
                        }
                        $AccumulatedInput.Clear()
                    }
                    $LastTypeName = $typeName
                }
                $null = $AccumulatedInput.Add($InputObject)

            } else {

                # Default Formatting rules
                $labels = @(foreach ($pr in $inputObject.psObject.properties)  { 
                    if ($inputObject -is [Data.DataRow]) { # DataRows are special (we do not want to display a number of properties)
                        if (-not ('RowError', 'RowState', 'Table', 'ItemArray', 'HasErrors' -contains $pr.Name)) {
                            $pr.Name 
                        }
                    } else {
                        $pr.Name 
                    }
                    
                })
                if (-not $labels) { return } 
                                
                if ($labels.Count -gt 8) {
                
                    $null = $htmlOut.Append("
<div class='${cssSafeTypeName}Item'>
")
                    foreach ($prop in $inputObject.psObject.properties) {
                        $null = $htmlOut.Append("
    <p class='${cssSafeTypeName}PropertyName'>$($prop.Name)</p>
    <blockquote class='${cssSafeTypeName}PropertyValue'>
        $($prop.Value)
    </blockquote>
")
                        
                    }
                    $null = $htmlOut.Append("
</div>
<hr class='${cssSafeTypeName}Separator' />
")              
                }  else {
                    $widthPercentage = 100 / $labels.Count
                    $typeName = $inputObject.pstypenames[0]
                    if (-not ($tablesForTypeNames[$typeName])) {                        
                        if (-not $psBoundParameters.id) { 
                            $id = "TableFor$($TypeName.Replace('/', '_Slash_').Replace('.', "_").Replace(" ", '_'))$($script:QuickRandom.Next())" 
                        } else {
                            $id = $psBoundParameters.id
                        }
                        $tableHeader = [Text.StringBuilder]::new()
                        if (-not $classChunk) { $classChunk = "class='$($TypeName.Replace('/', '_Slash_').Replace('.', "_").Replace(" ", '_').Replace("'","''"))'"}
                        $null = $tableHeader.Append("
<table id='${id}${randomSalt}' $cssStyleChunk $classChunk >
    <thead>
    <tr>")   


                        foreach ($label in $labels) {
                            $null = $tableHeader.Append("
        <th style='font-size:1.1em;text-align:left;line-height:133%;width:${widthPercentage}%'>$([Security.SecurityElement]::Escape($label))<hr/></th>")
                    
                            
                        }
                        $null = $tableHeader.Append("
    </tr>
    </thead>
    <tbody>")
                        $tablesForTypeNames[$typeName] = $tableHeader
                        $null = $typeNamesEncountered.Add($typeName)
                    }
                    
                    $currentTable = $tablesForTypeNames[$typeName]
            
                    # Add a row
                    $null = $currentTable.Append("
    <tr itemscope='' itemtype='$($typeName)'>") 

                    foreach ($label in $labels) {
                        $value = $inputObject.$label
                        $value = "$($value -join ([Environment]::NewLine))".Replace([Environment]::NewLine, '<BR/> ')                        
                        $null = $currentTable.Append("
        <td itemprop='$([Security.SecurityElement]::Escape($label))'>$($value.Replace('&', '&amp;'))</td>")                
                    }
                    $null = $currentTable.Append("
        </tr>")      
                    
                }         
            }      
        }
     
    }
    
    end {        
        if ($AccumulatedInput.Count) {
            $formatData = $Script:CachedformatData[$LastTypeName]
            $cssSafeTypeName =$LastTypeName.Replace('.','').Replace('#','')
                    
            if ($formatData.PipelineAware) {
                if ($formatData -is [ScriptBlock] -or $formatData -is [IO.FileInfo]) {
                    $null = $htmlOut.Append("$($AccumulatedInput | . $Script:CachedformatData[$typeName])")
                }
            } else {
                foreach ($_ in $AccumulatedInput) {
                    . $RunCustomFormatter $_
                }
            }

            
            $AccumulatedInput.Clear()
        }           
            $htmlOut = "$htmlOut" 
            $htmlOut += if ($tablesForTypeNames.Count) {
                foreach ($table in $typeNamesEncountered) {
                    $null = $tablesForTypeNames[$table].Append("
    </tbody>
</table>")
                    
                    if ($escape) {
                        [Web.HttpUtility]::HtmlEncode($tablesForTypeNames[$table].ToString())
                    } else {
                        $tablesForTypeNames[$table].ToString()
                                                
                    }                    
                    
                }
            }
            
            if ($itemType) {
                $htmlout = "<div itemscope='' itemtype='$($itemType -join ' ')'>
$htmlOut
</div>"
            }

                        
            $htmlOut
            
        
    }
}
