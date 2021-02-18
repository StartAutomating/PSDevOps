function Add-Git
{
    <#
    .Synopsis
        PowerShell wrapper around git add
    .Description
        Adds changes to a git changelist
    #>
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess=$true)]
    param(
    <#
    Don't actually add the file(s), just show if they exist and/or will
    be ignored.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--dry-run','N')]
    [switch]
    $DryRun,
    <#
    Allow adding otherwise ignored files.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--force','F')]
    [switch]
    $Force,
    <#
    Add modified contents in the working tree interactively to
    the index. Optional path arguments may be supplied to limit
    operation to a subset of the working tree. See Interactive
    mode for details.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--interactive','I')]
    [switch]
    $Interactive,
    <#
    Interactively choose hunks of patch between the index and the
    work tree and add them to the index. This gives the user a chance
    to review the difference before adding modified contents to the
    index.

    This effectively runs add --interactive, but bypasses the
    initial command menu and directly jumps to the patch subcommand.
    See 'Interactive mode' for details.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--patch','P')]
    [switch]
    $Patch,
    <#
    Open the diff vs. the index in an editor and let the user
    edit it.  After the editor was closed, adjust the hunk headers
    and apply the patch to the index.

    The intent of this option is to pick and choose lines of the patch to
    apply, or even to modify the contents of lines to be staged. This can be
    quicker and more flexible than using the interactive hunk selector.
    However, it is easy to confuse oneself and create a patch that does not
    apply to the index. See EDITING PATCHES below.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--edit','E')]
    [switch]
    $Edit,
    <#
    Record only the fact that the path will be added later. An entry
    for the path is placed in the index with no content. This is
    useful for, among other things, showing the unstaged content of
    such files with git diff and committing them with git commit
    -a.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--intent-to-add')]
    [switch]
    $IntentToAdd,
    <#
    Don't add the file(s), but only refresh their stat()
    information in the index.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--refresh')]
    [switch]
    $Refresh,
    <#
    If some files could not be added because of errors indexing
    them, do not abort the operation, but continue adding the
    others. The command shall still exit with non-zero status.
    The configuration variable add.ignoreErrors can be set to
    true to make this the default behaviour.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--ignore-errors')]
    [switch]
    $IgnoreErrors,
    <#
    This option can only be used together with --dry-run. By using
    this option the user can check if any of the given files would
    be ignored, no matter if they are already present in the work
    tree or not.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--ignore-missing')]
    [switch]
    $IgnoreMissing,
    <#
    Apply the "clean" process freshly to all tracked files to
    forcibly add them again to the index.  This is useful after
    changing core.autocrlf configuration or the text attribute
    in order to correct files added with wrong CRLF/LF line endings.
    This option implies -u.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--renormalize')]
    [switch]
    $Renormalize,
    [Parameter(ValueFromPipelineByPropertyName,ValueFromRemainingArguments)]
    [string[]]
    $Pathspec
    )

    begin {
        $myCommandMetadata = [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
    }
    process {
        $exeArgs = @()
        $exeArgs +=
            foreach ($kv in $PSBoundParameters.GetEnumerator()) {
                $paramMetadata = $myCommandMetadata.Parameters[$kv.Key]
                if (-not $paramMetadata) { continue }
                if ($paramMetadata.Aliases[0] -match '[-/]') {
                    if ($paramMetadata.Aliases[0] -match '\=$') {
                        $paramMetadata.Aliases[0] + '=' + "$($kv.Value)"
                    } else {
                        $paramMetadata.Aliases[0]
                        if ($paramMetadata.ParameterType -ne [switch]) {
                            "$($kv.Value)"
                        }
                    }

                }
                elseif (-not ($paramMetadata.Aliases -match '^\!')) {
                    foreach ($v in $kv.Value) { "$v" }
                }
            }
        if ($WhatIfPreference) {
            return $exeArgs
        }
        git add @exeArgs 2>&1
    }
}

