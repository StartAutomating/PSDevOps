function Invoke-GitHubRestAPI
{
    <#
    .Synopsis
        Invokes the Git Rest API
    .Description
        Invokes the GitHub REST API
    .Example
        # Uses the Azure DevOps REST api to get builds from a project
        $org = 'StartAutomating'
        $repo = 'PSDevOps'
        Invoke-GitRestAPI "https://api.github.com/repos/StartAutomating/PSDevOps"
    .Link
        Invoke-RestMethod
    #>
    [OutputType([PSObject])]
    [CmdletBinding(DefaultParameterSetName='Url')]
    param(
    # The REST API Url
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('Url')]
    [uri]
    $Uri,

    <#
Specifies the method used for the web request. The acceptable values for this parameter are:
 - Default
 - Delete
 - Get
 - Head
 - Merge
 - Options
 - Patch
 - Post
 - Put
 - Trace
    #>
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [ValidateSet('GET','DELETE','HEAD','MERGE','OPTIONS','PATCH','POST', 'PUT', 'TRACE')]
    [string]
    $Method = 'GET',

    # Specifies the body of the request.
    # If this value is a string, it will be passed as-is
    # Otherwise, this value will be converted into JSON.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Object]
    $Body,

    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('UrlParameters')]
    [Collections.IDictionary]
    $UrlParameter = @{},

    # Additional parameters provided in the query string.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('QueryParameters')]
    [Collections.IDictionary]
    $QueryParameter = @{},

    # A Personal Access Token
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('PAT')]
    [string]
    $PersonalAccessToken,

    # The page number.  If provided, will only get one page of results.
    # If this is not provided, additional results will be fetched until they are exhausted.
    [Parameter(ParameterSetName='Url')]
    [int]
    $Page,

    # The number of items to retreive on a single page.
    [Parameter(ParameterSetName='Url')]
    [Alias('Per_Page')]
    [int]
    $PerPage,
  
    # The typename of the results.
    # If not set, will be the depluralized last non-variable segment of a URL.
    # (i.e. "https://api.github.com/user/repos" would use a typename of 'repos'
    # so would: "https://api.github.com/users/{UserName}/repos")
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('Decorate','Decoration')]
    [string[]]
    $PSTypeName,

    # A set of additional properties to add to an object
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Collections.IDictionary]
    $Property,

    # A list of property names to remove from an object
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [string[]]
    $RemoveProperty,

    # If provided, will expand a given property returned from the REST api.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [string]
    $ExpandProperty,

    # If provided, will decorate the values within a property in the return object.
    # This allows nested REST properties to work with the PowerShell Extended Type System.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('TypeNameOfProperty')]
    [Collections.IDictionary]    
    $DecorateProperty,

    # If set, will cache results from a request.  Only HTTP GET results will be cached.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Cache,

    # If set, will run as a background job.
    # This parameter will be ignored if the caller is piping the results of Invoke-ADORestAPI.
    # This parameter will also be ignore when calling with -DynamicParameter or -MapParameter.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $AsJob,

    # If set, will get the dynamic parameters that should be provided to any function that wraps Invoke-ADORestApi
    [Parameter(Mandatory,ParameterSetName='GetDynamicParameters',ValueFromPipelineByPropertyName)]
    [Alias('DynamicParameters')]
    [switch]
    $DynamicParameter,

    # If set, will return the parameters for any function that can be passed to Invoke-ADORestApi.
    # Unmapped parameters will be added as a noteproperty of the returned dictionary.
    [Parameter(Mandatory,ParameterSetName='MapParameters',ValueFromPipelineByPropertyName)]
    [Alias('MapParameters')]
    [Collections.IDictionary]
    $MapParameter,

    # The GitAPIUrl
    # This will used if -Uri does not contain a hostname.
    # It will default to $env:GIT_API_URL if it is set, otherwise 'https://api.github.com/'
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [uri]
    $GitApiUrl = $(if ($env:GIT_API_URL) { $env:GIT_API_URL} else { "https://api.github.com/" } ),

    # Specifies the content type of the web request.
    # If this parameter is omitted and the request method is POST, Invoke-RestMethod sets the content type to application/x-www-form-urlencoded. Otherwise, the content type is not specified in the call.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [string]
    $ContentType = 'application/json',

    # Specifies the headers of the web request. Enter a hash table or dictionary.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [Alias('Header')]
    [Collections.IDictionary]
    $Headers,

    # Provides a custom user agent.  GitHub API requests require a User Agent.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Url')]
    [string]
    $UserAgent = "PSDevOps/1.0 (StartAutomating;PSDevOps;Invoke-GitRESTApi)"

    )

    begin {
        $RestVariable = [Regex]::new(@'
# Matches URL segments and query strings containing variables.
# Variables can be enclosed in brackets or curly braces, or preceeded by a $ or :
(?>                           # A variable can be in a URL segment or subdomain
    (?<Start>[/\.])           # Match the <Start>ing slash|dot ...
    (?<IsOptional>\?)?        # ... an optional ? (to indicate optional) ...
    (?:          
        \{(?<Variable>\w+)\}| # ... A <Variable> name in {} OR
        \[(?<Variable>\w+)\]| #     A <Variable> name in [] OR
        `\$(?<Variable>\w+) | #     A `$ followed by a <Variable> OR
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
       `\$(?<Variable>\w+)  | #     A `$ followed by a <Variable> OR  
        \:(?<Variable>\w+)    #     A : followed by a <Variable>
    )
)
'@, 'IgnoreCase,IgnorePatternWhitespace')
        
        $ReplaceRestVariable = {
            param($match)
            
            if ($urlParameter -and $urlParameter[$match.Groups["Variable"].Value]) {
                return $match.Groups["Start"].Value + $(
                        if ($match.Groups["Query"].Success) { $match.Groups["Query"].Value + '=' }
                    ) +
                    ([Web.HttpUtility]::UrlEncode(
                        $urlParameter[$match.Groups["Variable"].Value]
                    ))
            } else {
                return ''
            }
        }

        if (-not $gitProgressId -and 
            ($ProgressPreference -ne 'silentlycontinue')
        ) {
            $gitProgressId = [Random]::new().Next() 
        }

        if ($MyInvocation.InvocationName -ne $MyInvocation.MyCommand.Name -and
            $MyInvocation.InvocationName -like "$GitApiUrl*") {
            $GitApiUrl = $MyInvocation.InvocationName
        }
    }

    process {
        $irmSplat = @{} + $PSBoundParameters    # First, copy PSBoundParameters.
        if ($PSCmdlet.ParameterSetName -eq 'GetDynamicParameters') {
            if (-not $script:InvokeGitRESTApiParams) {
                $script:InvokeGitRESTApiParams = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
                $InvokeGitRESTApi = $MyInvocation.MyCommand
                :nextInputParameter foreach ($in in ([Management.Automation.CommandMetaData]$InvokeGitRESTApi).Parameters.Keys) {
                    if ($in -notin 'Cache', 'PersonalAccessToken', 'AsJob') { continue nextInputParameter }

                    $script:InvokeGitRESTApiParams.Add($in, [Management.Automation.RuntimeDefinedParameter]::new(
                        $InvokeGitRESTApi.Parameters[$in].Name,
                        $InvokeGitRESTApi.Parameters[$in].ParameterType,
                        $InvokeGitRESTApi.Parameters[$in].Attributes
                    ))
                }
                foreach ($paramName in $script:InvokeGitRESTApiParams.Keys) {
                    foreach ($attr in $script:InvokeGitRESTApiParams[$paramName].Attributes) {
                         if ($attr.ValueFromPipeline) {$attr.ValueFromPipeline = $false}
                         if ($attr.ValueFromPipelineByPropertyName) {$attr.ValueFromPipelineByPropertyName = $false}
                    }
                }
            }
            return $script:InvokeGitRESTApiParams
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'MapParameters') {
            $invokeParams = [Ordered]@{} + $MapParameter # Then we copy our parameters
            $unmapped     = [Ordered]@{}
            foreach ($k in @($invokeParams.Keys)) {  # and walk thru each parameter name.
                # If a parameter isn't found in Invoke-ADORestAPI
                if (-not $MyInvocation.MyCommand.Parameters.ContainsKey($k)) {
                    $unmapped[$k] = $invokeParams[$k]
                    $invokeParams.Remove($k) # we remove it.
                }
            }            
            $invokeParams.psobject.properties.add([PSNoteProperty]::new('Unmapped',$unmapped))
            return $invokeParams
        }
        
        #region Prepare Parameters
        
        if (-not $PersonalAccessToken -and $script:CachedGitPAT) {
            $PersonalAccessToken = $psBoundParameters['PersonalAccessToken'] = $script:CachedGitPAT # Then, use a cached PAT if appropriate.
        }
        if ($AsJob -and ($MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength)) {
            $irmSplat.Remove('AsJob')
            Start-Job -ScriptBlock ([ScriptBlock]::Create("param([Hashtable]`$parameter)
function $($MyInvocation.MyCommand.Name) {
$($MyInvocation.MyCommand.ScriptBlock)
}
$($MyInvocation.MyCommand.Name) @parameter
")) -ArgumentList $irmSplat
        }

        $authHeaderType = # Next we need to determine the correct auth header.
            # If we're using the graph API, it's 'bearer'
            if ($uri.Segments.Length -ge 2 -and $Uri.Segments[1] -eq 'graphql') { 
                "bearer"
            } else { 
                "token"  # otherwise, it's 'token'.
            }

        if (-not $uri.Host -and 
            $uri -match "\w+\s+(?:http|/)") {
            $method, $uri = $uri -split ' '            
        }

        if (-not $uri.host -and $GitApiUrl)  {
            $uri = "$GitApiUrl" + $Uri
        }

        

        
        $originalUri = "$uri"
        $uri = $RestVariable.Replace($uri, $ReplaceRestVariable)

        if ($Page) { $QueryParameter['page'] = $Page }
        if ($PerPage) { $QueryParameter['per_page']  = $PerPage }
        if ($QueryParameter -and $QueryParameter.Count) {
            $uri = 
                "$uri" +
                $(if (-not $uri.Query) { '?' } else { '&' }) +
                @(
                    foreach ($qp in $QueryParameter.GetEnumerator()) {
                        '' + $qp.Key + '=' + [Web.HttpUtility]::UrlEncode($qp.Value).Replace('+', '%20')
                    }
                ) -join '&'
        }

        if (-not $script:GitRequestCache) { $script:GitRequestCache = @{} }
        if ($Cache -and $method -eq 'Get' -and $script:GitRequestCache[$uri]) {
            foreach ($out in $script:GitRequestCache[$uri]) { $out }
            return
        }
        
        if ($PersonalAccessToken) { # If there was a personal access token, set the authorization header
            if ($Headers) { # (make sure not to step on other headers).
                $irmSplat.Headers.Authorization = "$authHeaderType $PersonalAccessToken"
            }
            else {
                $irmSplat.Headers = @{ Authorization = "$authHeaderType $PersonalAccessToken" }
            }
            $script:CachedGitPAT = $PersonalAccessToken
        }
        if ($Body -and $Body -isnot [string]) { # If a body was passed, and it wasn't a string
            $irmSplat.Body = ConvertTo-Json -Depth 100 -InputObject $body # make it JSON.
        }
        if (-not $irmSplat.ContentType) { # If no content type was passed
            $irmSplat.ContentType = $ContentType # set it to the default.
        }
        #endregion Prepare Parameters

        #region Call Invoke-RestMethod
        

        $webRequest =  [Net.HttpWebRequest]::Create($uri)
        $webRequest.Method = $Method
        $webRequest.contentType = $ContentType
        $irmSplat.UserAgent = $webRequest.UserAgent = $UserAgent
        if ($irmSplat.Headers) {
            foreach ($h in $irmSplat.Headers.GetEnumerator()) {
                $webRequest.headers.add($h.Key, $h.Value)
            }
        }
        if ($irmSplat.Body) {
            $bytes = [Text.Encoding]::UTF8.GetBytes($irmSplat.Body)
            $webRequest.contentLength = $bytes.Length
            $requestStream = $webRequest.GetRequestStream()
            $requestStream.Write($bytes, 0, $bytes.Length)
            $requestStream.Close()
        } else {
            $webRequest.contentLength = 0
        }

        Write-Verbose "$Method $Uri [$($webRequest.ContentLength) bytes]"               

        $response = . {

            $webResponse =
                try {
                    $WebRequest.GetResponse()
                } catch {
                    $ex = $_
                    if ($ex.Exception.InnerException.Response) {
                        $streamIn = [IO.StreamReader]::new($ex.Exception.InnerException.Response.GetResponseStream())
                        $strResponse = $streamIn.ReadToEnd()
                        $streamIn.Close()
                        $streamIn.Dispose()
                        $errorRecord = [Management.Automation.ErrorRecord]::new($ex.Exception.InnerException, $ex.Exception.HResult, 'NotSpecified', $webRequest)
                        $PSCmdlet.WriteError($errorRecord)
                        return
                    } else {
                        $errorRecord = [Management.Automation.ErrorRecord]::new($ex.Exception, $ex.Exception.HResult, 'NotSpecified', $webRequest)
                        $PSCmdlet.WriteError($errorRecord)
                        return
                    }
                }
            $rs = $webresponse.GetResponseStream()
            $responseHeaders = $webresponse.Headers
            $responseHeaders =
                if ($responseHeaders -and $responseHeaders.GetEnumerator()) {
                    $reHead = @{}
                    foreach ($r in $responseHeaders.GetEnumerator()) {
                        $reHead[$r] = $responseHeaders[$r]
                    }
                    $reHead
                } else {
                    @{}
                }

            $streamIn = [IO.StreamReader]::new($rs, $webResponse.Contentencoding)
            $strResponse = $streamIn.ReadToEnd()
            if ($webResponse.ContentType -like '*json*') {
                try {
                    $strResponse | ConvertFrom-Json
                } catch {
                    $strResponse
                }
            } else {
                $strResponse
            }

            $streamIn.Close()

        } 2>&1
        $null = $null
        # We call Invoke-RestMethod with the parameters we've passed in.
        # It will take care of converting the results from JSON.
        

        if (-not $PSTypeName) { # If we have no typename
            $PSTypeName = # the last non-variable uri segment, depluralized and trimming slashes will do
                ([uri]($RestVariable.Replace($originalUri, ''))).Segments[-1].TrimEnd('s').TrimEnd('/')
            $PSTypeName = $PSTypeName[0].TrimEnd('.') # then trim any trailing dot.
            $PSTypeName = 'PSDevOps.Git' + $PSTypeName[0].Substring(0,1).ToUpper() + $PSTypeName[0].Substring(1)
            $PSTypeName += 'PSDevOps.GitObject'
        }

        $apiOutput =
            $response | 
            & { process { # process each object in the response.
                $in = $_
                if ($Uri.Segments -and $uri.Segments[-1] -eq 'graphql') { # If it was from GraphQL
                    if ($in.data) {
                        $in.data # data is in .data 
                    }
                    elseif ($in.errors) { # and errors need to be turned in PowerShell errors.
                        foreach ($err in $in.errors) {
                            $psCmdlet.WriteError([Management.Automation.ErrorRecord]::new(
                                [Exception]::new($err.Message), 'Git.GraphQL.Error', 'InvalidOperation', $err
                            ))
                        }
                    }
                } else { # If it wasn't from GraphQL, pass it on down.
                    $in
                }
            } } |
            & { process { # One more step of the pipeline will unroll each of the values.
                if ($_ -is [string]) { return $_ }
                if ($null -ne $_.Count -and $_.Count -eq 0) { return }
                $in = $_
                if ($PSTypeName -and # If we have a PSTypeName (to apply formatting)
                    $in -isnot [Management.Automation.ErrorRecord] # and it is not an error (which we do not want to format)
                ) {
                    $in.PSTypeNames.Clear() # then clear the existing typenames and decorate the object.
                    foreach ($t in $PSTypeName) {
                        $in.PSTypeNames.add($T)
                    }
                }

                if ($in.Initialize -is [PSScriptMethod]) {
                    $null = $in.Initialize.Invoke()
                }

                if ($Property) {
                    foreach ($propKeyValue in $Property.GetEnumerator()) {
                        if ($in.PSObject.Properties[$propKeyValue.Key]) {
                            $in.PSObject.Properties.Remove($propKeyValue.Key)
                        }
                        $in.PSObject.Properties.Add($(
                        if ($propKeyValue.Value -as [ScriptBlock[]]) {
                            [PSScriptProperty]::new.Invoke(@($propKeyValue.Key) + $propKeyValue.Value)
                        } else {
                            [PSNoteProperty]::new($propKeyValue.Key, $propKeyValue.Value)
                        }))
                    }
                }
                if ($RemoveProperty) {
                    foreach ($propToRemove in $RemoveProperty) {
                        $in.PSObject.Properties.Remove($propToRemove)
                    }
                }
                if ($DecorateProperty) {
                    foreach ($kv in $DecorateProperty.GetEnumerator()) {
                        if ($in.$($kv.Key)) {
                            foreach ($v in $in.$($kv.Key)) {
                                if ($null -eq $v -or -not $v.pstypenames) { continue }
                                $v.pstypenames.clear()
                                foreach ($tn in $kv.Value) {
                                    $v.pstypenames.add($tn)
                                }
                            }
                        }
                    }
                }
                return $in # output the object and we're done.
            } }
        #endregion Call Invoke-RestMethod

        # If we have a continuation token
        
        
        $paramCopy = @{} + $PSBoundParameters
        $invokeResults = [Collections.ArrayList]::new()
        & {
            if (-not $Page -and # If we weren't provided with a page number            
                $responseHeaders.Link -match # but out .Link header
                    '<(?<u>[^>]+)>; rel="next"' # has a 'next' uri
            ) {
            
                $apiOutput # output

                # Then recursively call yourself with the next uri                
                $uri = $PSBoundParameters['Uri'] = ($matches.u)
                if ($ProgressPreference -ne 'silentlycontinue' -and 
                    $responseHeaders.Link -match '<(?<u>[^>]+)>; rel="last"'
                ) {
                    $lastUri = [uri]$matches.u
                    $nextPageNumber = [Web.HttpUtility]::ParseQueryString(([uri]$Uri).Query)["page"] -as [float]
                    $lastPageNumber = [Web.HttpUtility]::ParseQueryString($lastUri.Query)["page"] -as [float]
                    Write-Progress "$Method" "$uri [$nextPageNumber/$lastPageNumber]" -PercentComplete (
                        $nextPageNumber * 100 / $lastPageNumber
                    ) -Id $gitProgressId
                }
                Invoke-GitRESTAPI @PSBoundParameters
            } else { # If we didn't have a next page, just output
                $apiOutput
            }
        } | & { process {
            $in = $_
            if ($in) {
                $null = $invokeResults.Add($in)
                $in

            }
        } }

        if ($Method -eq 'Get') {
            if ($Cache -and -not $ContinuationToken) {
                $script:GitRequestCache[$uri] = $invokeResults.ToArray()
            }
        } else {
            $null =
                New-Event -SourceIdentifier "Invoke-GitRESTApi.$Method" -MessageData $(
                    $paramCopy.Remove('PersonalAccessToken')
                    $paramCopy+=@{Response = $response;Results  = $invokeResults.ToArray() }
                    [PSCustomObject]$paramCopy
                )
        }

        if ($ProgressPreference -ne 'silentlycontinue') {
            Write-Progress "$Method" "$uri" -Completed -Id $gitProgressId
        }
    }
}