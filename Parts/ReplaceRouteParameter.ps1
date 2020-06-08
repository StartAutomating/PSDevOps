<#
.Synopsis
    Replaces a route parameter with variables
.Description
    Replaces a URL route parameter, in the form /{Variable}, with the contents of $Variable
#>
param(
# The route
[Parameter(Mandatory,Position=0)]
[uri]
$Route
)

[Regex]::Replace(
    "$Route",
    '/\{(?<Variable>\w+)\}',
    {param($match)
        $var = $ExecutionContext.SessionState.PSVariable.Get($match.Groups['Variable'].ToString())
        if (-not [string]::IsNullOrWhiteSpace($var.Value)) {
            return '/' + ([Web.HttpUtility]::UrlEncode($var.Value.ToString()).Replace('+','%20'))
        } else {
            return ''
        }
    }
)
