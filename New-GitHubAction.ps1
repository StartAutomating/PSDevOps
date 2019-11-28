function New-GitHubAction {
    <#
    .Synopsis
        Creates a new GitHub Action
    .Description
        Create a new GitHub Action Pipeline.
    .Example
        New-GitHubAction -Stage TestPowerShellCrossPlatForm
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSPossibleIncorrectComparisonWithNull", "", Justification = "Explicitly checking for null (0 is ok)")]
    param(
    )

    "Hello from New-GitHubAction"
}