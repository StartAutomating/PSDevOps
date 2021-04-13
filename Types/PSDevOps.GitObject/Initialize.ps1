$RestVariable = [Regex]::new(@'
# Matches URL segments and query strings containing variables.
# Variables can be enclosed in brackets or curly braces, or preceeded by a $ or :
(?>                           # A variable can be in a URL segment or subdomain
    (?<Start>[/\.])           # Match the <Start>ing slash|dot ...
    (?<IsOptional>\?)?        # ... an optional ? (to indicate optional) ...
    (?:          
        \{(?<Variable>\w+)\}| # ... A <Variable> name in {} OR
        \[(?<Variable>\w+)\]| #     A <Variable> name in [] OR
        \$(?<Variable>\w+)  | #     A $ followed by a <Variable> OR
        \:(?<Variable>\w+)    #     A : followed by a <Variable>
    )    
|
    (?<IsOptional>            # If it's optional it can also be 
        [{\[](?<Start>/)      # a bracket or brace, followed by a slash
    )
    (?<Variable>\w+)[}\]]     # then a <Variable> name followed by } or ]
|                             # OR it can be in a query parameter:
    (?<Start>[?&])            # Match The <Start>ing ? or & ...
    (?<Query>[\w\-]+)         # ... the <Query> parameter name ... 
    =                         # ... an equals ...
    (?<IsOptional>\?)?        # ... an optional ? (to indicate optional) ...
    (?:               
        \{(?<Variable>\w+)\}| # ... A <Variable> name in {} OR
        \[(?<Variable>\w+)\]| #     A <Variable> name in [] OR
        \$(?<Variable>\w+)  | #     A $ followed by a <Variable> OR
        \:(?<Variable>\w+)    #     A : followed by a <Variable>
    )
)
'@, 'IgnoreCase,IgnorePatternWhitespace')
        
foreach ($property in $this.psobject.properties) {
    if (-not $property.Name.EndsWith("_url")) { continue }
    $params = @(foreach ($match in $RestVariable.Matches($property.Value)) {
        '$' + $match.Groups["Variable"].Value
    }) -join ','
    $newMethodName = $property.Name.Substring(0, $property.Name.Length - 4) -replace '_'
    $newMethodName = 'Get' + $newMethodName.Substring(0,1).ToUpper() + $newMethodName.Substring(1)
    
    if (-not $this.$newMethodName) {
        $this.psobject.methods.add([PSScriptMethod]::new(
            $newMethodName, 
            [ScriptBlock]::Create(@"
param($params) Invoke-GitRESTApi -Uri '$($property.Value)' -UrlParameter `$psboundParameters
"@)
        ))
    }
}