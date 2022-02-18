function Submit-Git
{
    <#
    .Synopsis
        PowerShell wrapper around git commit
    .Description
        Submits a git changelist to the repository, creating a new commit.
    .Example
        Submit-Git -Message "Commit Messages Should Be Helpful"

    #>
    [CmdletBinding(PositionalBinding=$false,SupportsShouldProcess)]    
    param(
    # Use the given <msg> as the commit message.
    # The -m option is mutually exclusive with -c, -C, and -F
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--message','M')]
    [string[]]
    $Message,

    # Tell the command to automatically stage files that have been modified and deleted, 
    # but new files you have not told Git about are not affected.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--all','A')]
    [switch]
    $All,

    # Use the interactive patch selection interface to chose which changes to commit.
    # See git-add(1) for details.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--patch','P')]
    [switch]
    $Patch,

    # Take an existing commit object, and reuse the log message 
    # and the authorship information (including the timestamp) when creating the commit.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--resuse_message=','C')]
    [string]
    $Commit,

    # Like -Commit, but with -c the editor is invoked, so that the user can further edit the commit message.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--reedit-message=','ReEditMessage')]
    [string]
    $ReEditCommit,

    # Construct a commit message for use with rebase --autosquash. 
    # The commit message will be the subject line from the specified commit with a prefix of "fixup! ".
    # See git-rebase(1) for details.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--fixup=','FixCommit', 'Fix')]
    [string]
    $FixupCommit,

    # Construct a commit message for use with rebase --autosquash. 
    # The commit message subject line is taken from the specified commit with a prefix of "squash! ".
    # Can be used with additional commit message options (-m/-c/-C/-F). 
    # See git-rebase(1) for details.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--squash=')]
    [string]
    $Squash,




    # When used with -C/-c/--amend options, 
    # or when committing after a conflicting cherry-pick, 
    # declare that the authorship of the resulting commit now belongs to the committer. 
    # This also renews the author timestamp.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--reset-author')]
    [switch]
    $ResetAuthor,

    # When doing a dry-run, give the output in the short-format. 
    # See git-status(1) for details. Implies --dry-run.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--short')]
    [switch]
    $Short,

    # Show the branch and tracking info even in short-format.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--branch')]
    [switch]
    $Branch,

    # When doing a dry-run, give the output in a porcelain-ready format. 
    # See git-status(1) for details. Implies --dry-run.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--porcelain')]
    [switch]
    $Porcelain,

    # When doing a dry-run, give the output in the long-format. Implies --dry-run.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--long')]
    [switch]
    $Long,

    <#
    When showing short or porcelain status output, print the filename verbatim and terminate the entries with NUL, instead of LF.
    If no format is given, implies the --porcelain output format.
    Without the -z option, filenames with "unusual" characters are quoted as explained for the configuration variable core.quotePath
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--null','Z','Null')]
    [switch]
    $NullTerminatedOutput,

    # Take the commit message from the given file. 
    # Use - to read the message from the standard input.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--file', 'F')]
    [string]
    $File,
    
    # Override the commit author. 
    # Specify an explicit author using the standard A U Thor <author@example.com> format. 
    # Otherwise <author> is assumed to be a pattern and is used to search for an existing commit by that author 
    # (i.e. rev-list --all -i --author=<author>); 
    # the commit author is then copied from the first such commit found.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--author=')]
    [string]
    $Author,

    # Override the author date used in the commit.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--date')]
    [string]
    $Date,


    # When editing the commit message, start the editor with the contents in the given file.
    # The commit.template configuration variable is often used 
    # to give this option implicitly to the command.
    # This mechanism can be used by projects that want to guide participants with some hints 
    # on what to write in the message in what order. 
    # If the user exits the editor without editing the message, the commit is aborted.
    # This has no effect when a message is given by other means, e.g. with the -m or -F options.
    
    
    
    # Add Signed-off-by line by the committer at the end of the commit log message. 
    # The meaning of a signoff depends on the project, 
    # but it typically certifies that committer has the rights to submit this work 
    # under the same license and agrees to a Developer Certificate of Origin 
    # (see http://developercertificate.org/ for more information).
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--signoff')]
    [switch]
    $SignOff,

    # This option bypasses the pre-commit and commit-msg hooks.
    # See also githooks(5).
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-verify')]
    [switch]
    $NoVerify,


    <#
    Usually recording a commit that has the exact same tree as its
    sole parent commit is a mistake, and the command prevents you
    from making such a commit.  This option bypasses the safety, and
    is primarily for use by foreign SCM interface scripts.
    #>[Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--allow-empty')]
    [switch]
    $AllowEmpty,

    <#
    Like --allow-empty this command is primarily for use by foreign
    SCM interface scripts. It allows you to create a commit with an
    empty commit message without using plumbing commands like
    git-commit-tree(1).
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--allow-empty-message')]
    [switch]
    $AllowEmptyMessage,

    # This option determines how the supplied commit message should be cleaned up before committing.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('strip','whitespace','verbatim','scissors','default')]
    [Alias('--cleanup=')]
    [string]
    $Cleanup,

    # The message taken from file with -F, command line with -m, and from commit object with -C are usually used as the commit log message unmodified. 
    # This option lets you further edit the message taken from these sources.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--edit', 'E')]
    [switch]
    $Edit,

    # Use the selected commit message without launching an editor. 
    # For example, git commit --amend --no-edit amends a commit without changing its commit message.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-edit')]
    [switch]
    $NoEdit,

    <#
    Replace the tip of the current branch by creating a new
    commit. The recorded tree is prepared as usual (including
    the effect of the -i and -o options and explicit
    pathspec), and the message from the original commit is used
    as the starting point, instead of an empty message, when no
    other message is specified from the command line via options
    such as -m, -F, -c, etc.  The new commit has the same
    parents and author as the current one (the --reset-author
    option can countermand this).



    It is a rough equivalent for:



	    $ git reset --soft HEAD^
	    $ ... do something else to come up with the right tree ...
	    $ git commit -c ORIG_HEAD



    but can be used to amend a merge commit.


    You should understand the implications of rewriting history if you
    amend a commit that has already been published.  (See the "RECOVERING
    FROM UPSTREAM REBASE" section in git-rebase(1).)
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--amend')]
    [switch]
    $Amend,


    # Bypass the post-rewrite hook.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-post-rewrite')]
    [switch]
    $NoPostRewrite,

    # Before making a commit out of staged contents so far, 
    # stage the contents of paths given on the command line as well. 
    # This is usually not what you want unless you are concluding a conflicted merge.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--include')]
    [switch]
    $Include,

    <#

    Make a commit by taking the updated working tree contents of the paths specified on the command line, 
    disregarding any contents that have been staged for other paths.

    This is the default mode of operation of git commit if any paths are given on the command line, 
    in which case this option can be omitted.

    If this option is specified together with --amend, then no paths need to be specified, 
    which can be used to amend the last commit without committing changes that have already been staged. 

    If used together with --allow-empty paths are also not required, and an empty commit will be created.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--only','O')]
    [switch]
    $Only,

    <#

    Show untracked files.

    The mode parameter is optional (defaults to all), 
    and is used to specify the handling of untracked files; 
    when -u is not used, the default is normal, i.e. show untracked files and directories.

    The possible options are:

    * no - Show no untracked files
    * normal - Shows untracked files and directories
    * all - Also shows individual files in untracked directories.

    The default can be changed using the status.showUntrackedFiles configuration variable 
    documented in git.config
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--untracked-files=','UntrackedFiles')]
    [ValidateSet('No','Normal','All')]
    [string]
    $UntrackedFile,

    # Suppress commit summary message.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--quiet','Q')]
    [switch]
    $Quiet,

    <#
    Do not create a commit, but show a list of paths that are
    to be committed, paths with local changes that will be left
    uncommitted and paths that are untracked.
    #>
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--dry-run')]
    [switch]
    $DryRun,


    # Include the output of git-status(1) in the commit message template 
    # when using an editor to prepare the commit message. 
    # Defaults to on, but can be used to override configuration variable commit.status.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--status')]
    [switch]
    $Status,


    # Do not include the output of git-status(1) in the commit message template 
    # when using an editor to prepare the default commit message.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-status')]
    [switch]
    $NoStatus,

    # GPG-sign commits. 
    # The keyid argument is optional and defaults to the committer identity; 
    # if specified, it must be stuck to the option without a space
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--gpg-sign=')]
    [string]
    $GPGSign,

    # Countermand commit.gpgSign configuration variable that is set to force each and every commit to be signed.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('--no-gpg-sign')]
    [switch]
    $NoGPGSign
    )

    begin {
        $myCommandMetadata = [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
        
    }
    process {
        $exeArgs = 
            @(& $getExeArguments $myCommandMetadata $PSBoundParameters @(
                if ($VerbosePreference -eq 'continue') { '--verbose' } 
            ))
       
        if ($WhatIfPreference) { return $exeArgs }

        if ($PSCmdlet.ShouldProcess("git commit $exeArgs")) {
            @(git commit @exeArgs 2>&1) -join [Environment]::NewLine
        }
    }

}
