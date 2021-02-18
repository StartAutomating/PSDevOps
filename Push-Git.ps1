function Push-Git
{
    <#
    .Synopsis
        PowerShell Wrapper around git push    
    .Description
        Pushes changes to a git repository.
    .Example
        Push-Git
    .Link
        Add-Git
    .Link
        Submit-Git
    #>
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess)]
    param(
    # The <repository> argument.
    [Parameter(Position=0,ValueFromPipelineByPropertyName)]
    [Alias('<repository>','Repo')]
    [string]
    $Repository,

    <#

Specify what destination ref to update with what source object. 
The format of a <refspec> parameter is an optional plus +, 
followed by the source object <src>, followed by a colon :, 
followed by the destination ref <dst>.

The <src> is often the name of the branch you would want to push, 
but it can be any arbitrary "SHA-1 expression", 
such as master~4 or HEAD (see gitrevisions(7)).

The <dst> tells which ref on the remote side is updated with this push. 
Arbitrary expressions cannot be used here, an actual ref must be named. 
If git push [<repository>] without any <refspec> argument is set to update 
some ref at the destination with <src> with remote.<repository>.push configuration variable,
 :<dst> part can be omitted—​such a push will update a ref that <src> normally updates without any <refspec> 
on the command line. 
Otherwise, missing :<dst> means to update the same ref as the <src>.

The object referenced by <src> is used to update the <dst> reference on the remote side.
By default this is only allowed if <dst> is not a tag (annotated or lightweight), 
and then only if it can fast-forward <dst>.

By having the optional leading +, you can tell Git to update the <dst> ref even 
if it is not allowed by default (e.g., it is not a fast-forward.) 
This does not attempt to merge <src> into <dst>.

tag <tag> means the same as refs/tags/<tag>:refs/tags/<tag>.

Pushing an empty <src> allows you to delete the <dst> ref from the remote repository.

The special refspec : (or +: to allow non-fast-forward updates) directs Git to push "matching" branches: 
for every branch that exists on the local side, 
the remote side is updated if a branch of the same name already exists on the remote side.
    #>
    [Parameter(Position=1,ValueFromPipelineByPropertyName,ValueFromRemainingArguments)]
    [Alias('<RefSpec>','RefSpec')]
    [string[]]
    $ReferenceSpec,
    
    
    # Push all branches (i.e. refs under refs/heads/); cannot be used with other <refspec>.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--all')]        
    [switch]
    $All,


    <#
    Remove remote branches that don’t have a local counterpart.
    For example a remote branch tmp will be removed if a 
    local branch with the same name doesn’t exist any more.
    
    This also respects refspecs, e.g. 
    git push --prune remote refs/heads/*:refs/tmp/* 
    would make sure that remote refs/tmp/foo will be removed if refs/heads/foo doesn’t exist.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--prune')]        
    [switch]
    $Prune,
    
    <#
    Instead of naming each ref to push, 
    specifies that all refs under refs/ 
    (which includes but is not limited to refs/heads/, refs/remotes/, and refs/tags/) 
    be mirrored to the remote repository.
    
    Newly created local refs will be pushed to the remote end, 
    locally updated refs will be force updated on the remote end, 
    and deleted refs will be removed from the remote end.
    
    This is the default if the configuration option remote.<remote>.mirror is set.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--mirror')]
    [switch]
    $Mirror,

    # Do everything except actually send the updates.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--dry-run','n')]
    [switch]
    $DryRun,

    # Produce machine-readable output. 
    # The output status line for each ref will be tab-separated and sent to stdout instead of stderr. 
    # The full symbolic names of the refs will be given.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--porcelain')]
    [switch]
    $Porcelain,


    # All listed refs are deleted from the remote repository. 
    # This is the same as prefixing all refs with a colon.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--delete','Remove','d')]
    [switch]
    $Delete,
        
    # All refs under refs/tags are pushed, in addition to refspecs explicitly listed on the command line.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--tags','Tags')]
    [switch]
    $Tag,

    <#
    Push all the refs that would be pushed without this option, 
    and also push annotated tags in refs/tags that are missing from the remote 
    but are pointing at commit-ish that are reachable from the refs being pushed. 
    
    This can also be specified with configuration variable push.followTags. 
    
    For more information, see push.followTags in git-config(1).
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--follow-tags','FollowTags')]
    [switch]
    $FollowTag,

    # Use an atomic transaction on the remote side if available. Either all refs are updated, or on error, no refs are updated. 
    # If the server does not support atomic pushes the push will fail.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--atomic')]
    [switch]
    $Atomic,

    <#
Transmit the given string to the server, 
which passes them to the pre-receive as well as the post-receive hook. 

The given string must not contain a NUL or LF character. 
When multiple --push-option=<option> are given, 
they are all sent to the other side in the order listed on the command line. 

When no --push-option=<option> is given from the command line, 
the values of configuration variable push.pushOption are used instead.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--push-option=','PushOptions')]
    [string]
    $PushOption,

    
    <#
    Path to the git-receive-pack program on the remote end. 
    Sometimes useful when pushing to a remote repository over ssh, 
    and you do not have the program in a directory on the default $PATH.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--receive-pack=','GitReceivePack')]
    [string]
    $ReceivePack,

    <#
Usually, the command refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it.
Also, when --force-with-lease option is used, the command refuses to update a remote ref 
whose current value does not match what is expected.

This flag disables these checks, and can cause the remote repository to lose commits; 
use it with care.

Note that --force applies to all the refs that are pushed, 
hence using it with push.default set to matching or 
with multiple push destinations configured with 
remote.*.push may overwrite refs other than the current branch 
(including local refs that are strictly behind their remote counterpart). 
To force a push to only one branch, use a + in front of the refspec to push (e.g git push origin +master to force a push to the master branch). 
See the <refspec>... section above for details.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--force')]
    [switch]
    $Force,

    # For every branch that is up to date or successfully pushed, 
    # add upstream (tracking) reference, used by argument-less git-pull(1) and other commands.
    # For more information, see branch.<name>.merge in git-config(1)
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--set-upstream','u')]
    [switch]
    $SetUpstream,

    # If set, no signing will be attempted.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-signed')]
    [switch]
    $Unsigned,

    <#
    GPG-sign the push request to update refs on the receiving side, 
    to allow it to be checked by the hooks and/or be logged.
    If false or --no-signed, no signing will be attempted.
    If true or --signed, the push will fail if the server does not support signed pushes.
    If set to if-asked, sign if and only if the server supports signed pushes.
    The push will also fail if the actual call to gpg --sign fails. 
    See git-receive-pack for the details on the receiving end.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('true','false','if-asked')]
    [Alias('--signed')]
    [string]
    $Signed,

    # See git help push
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--force-with-lease=')]
    [string]
    $ForceWithLease,

    # Toggle the pre-push hook (see githooks(5)). 
    # The default is --verify, giving the hook a chance to prevent the push. 
    # With --no-verify, the hook is bypassed completely.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--noverify')]
    [switch]
    $NoVerify
    )
    begin {
        $myCommandMetadata = [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
    }
    process {
        #region Prepare git arguments
        $exeArgs = $exeArgs = & $getExeArguments $myCommandMetadata $PSBoundParameters @(
            if ($VerbosePreference -eq 'continue') { '--verbose' } 
        )
        #endregion Prepare git arguments

        if ($WhatIfPreference) {
            return $exeArgs
        }

        if ($PSCmdlet.ShouldProcess("git push $exeArgs")) {
            @(git push @exeArgs 2>&1 | 
                & { process { "$_" } } )
        }
    }
}
