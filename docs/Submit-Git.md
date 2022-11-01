Submit-Git
----------
### Synopsis
PowerShell wrapper around git commit

---
### Description

Submits a git changelist to the repository, creating a new commit.

---
### Examples
#### EXAMPLE 1
```PowerShell
Submit-Git -Message "Commit Messages Should Be Helpful"
```

---
### Parameters
#### **Message**

Use the given <msg> as the commit message.
The -m option is mutually exclusive with -c, -C, and -F



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **All**

Tell the command to automatically stage files that have been modified and deleted, 
but new files you have not told Git about are not affected.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Patch**

Use the interactive patch selection interface to chose which changes to commit.
See git-add(1) for details.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Commit**

Take an existing commit object, and reuse the log message 
and the authorship information (including the timestamp) when creating the commit.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ReEditCommit**

Like -Commit, but with -c the editor is invoked, so that the user can further edit the commit message.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FixupCommit**

Construct a commit message for use with rebase --autosquash. 
The commit message will be the subject line from the specified commit with a prefix of "fixup! ".
See git-rebase(1) for details.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Squash**

Construct a commit message for use with rebase --autosquash. 
The commit message subject line is taken from the specified commit with a prefix of "squash! ".
Can be used with additional commit message options (-m/-c/-C/-F). 
See git-rebase(1) for details.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ResetAuthor**

When used with -C/-c/--amend options, 
or when committing after a conflicting cherry-pick, 
declare that the authorship of the resulting commit now belongs to the committer. 
This also renews the author timestamp.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Short**

When doing a dry-run, give the output in the short-format. 
See git-status(1) for details. Implies --dry-run.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Branch**

Show the branch and tracking info even in short-format.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Porcelain**

When doing a dry-run, give the output in a porcelain-ready format. 
See git-status(1) for details. Implies --dry-run.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Long**

When doing a dry-run, give the output in the long-format. Implies --dry-run.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NullTerminatedOutput**

When showing short or porcelain status output, print the filename verbatim and terminate the entries with NUL, instead of LF.
If no format is given, implies the --porcelain output format.
Without the -z option, filenames with "unusual" characters are quoted as explained for the configuration variable core.quotePath



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **File**

Take the commit message from the given file. 
Use - to read the message from the standard input.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Author**

Override the commit author. 
Specify an explicit author using the standard A U Thor <author@example.com> format. 
Otherwise <author> is assumed to be a pattern and is used to search for an existing commit by that author 
(i.e. rev-list --all -i --author=<author>); 
the commit author is then copied from the first such commit found.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Date**

Override the author date used in the commit.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SignOff**

Add Signed-off-by line by the committer at the end of the commit log message. 
The meaning of a signoff depends on the project, 
but it typically certifies that committer has the rights to submit this work 
under the same license and agrees to a Developer Certificate of Origin 
(see http://developercertificate.org/ for more information).



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoVerify**

This option bypasses the pre-commit and commit-msg hooks.
See also githooks(5).



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllowEmpty**

Usually recording a commit that has the exact same tree as its
sole parent commit is a mistake, and the command prevents you
from making such a commit.  This option bypasses the safety, and
is primarily for use by foreign SCM interface scripts.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **AllowEmptyMessage**

Like --allow-empty this command is primarily for use by foreign
SCM interface scripts. It allows you to create a commit with an
empty commit message without using plumbing commands like
git-commit-tree(1).



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Cleanup**

This option determines how the supplied commit message should be cleaned up before committing.



Valid Values:

* strip
* whitespace
* verbatim
* scissors
* default



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Edit**

The message taken from file with -F, command line with -m, and from commit object with -C are usually used as the commit log message unmodified. 
This option lets you further edit the message taken from these sources.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoEdit**

Use the selected commit message without launching an editor. 
For example, git commit --amend --no-edit amends a commit without changing its commit message.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Amend**

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



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoPostRewrite**

Bypass the post-rewrite hook.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Include**

Before making a commit out of staged contents so far, 
stage the contents of paths given on the command line as well. 
This is usually not what you want unless you are concluding a conflicted merge.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Only**

Make a commit by taking the updated working tree contents of the paths specified on the command line, 
disregarding any contents that have been staged for other paths.

This is the default mode of operation of git commit if any paths are given on the command line, 
in which case this option can be omitted.

If this option is specified together with --amend, then no paths need to be specified, 
which can be used to amend the last commit without committing changes that have already been staged. 

If used together with --allow-empty paths are also not required, and an empty commit will be created.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UntrackedFile**

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



Valid Values:

* No
* Normal
* All



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Quiet**

Suppress commit summary message.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DryRun**

Do not create a commit, but show a list of paths that are
to be committed, paths with local changes that will be left
uncommitted and paths that are untracked.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Status**

Include the output of git-status(1) in the commit message template 
when using an editor to prepare the commit message. 
Defaults to on, but can be used to override configuration variable commit.status.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoStatus**

Do not include the output of git-status(1) in the commit message template 
when using an editor to prepare the default commit message.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **GPGSign**

GPG-sign commits. 
The keyid argument is optional and defaults to the committer identity; 
if specified, it must be stuck to the option without a space



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NoGPGSign**

Countermand commit.gpgSign configuration variable that is set to force each and every commit to be signed.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Syntax
```PowerShell
Submit-Git [-Message <String[]>] [-All] [-Patch] [-Commit <String>] [-ReEditCommit <String>] [-FixupCommit <String>] [-Squash <String>] [-ResetAuthor] [-Short] [-Branch] [-Porcelain] [-Long] [-NullTerminatedOutput] [-File <String>] [-Author <String>] [-Date <String>] [-SignOff] [-NoVerify] [-AllowEmpty] [-AllowEmptyMessage] [-Cleanup <String>] [-Edit] [-NoEdit] [-Amend] [-NoPostRewrite] [-Include] [-Only] [-UntrackedFile <String>] [-Quiet] [-DryRun] [-Status] [-NoStatus] [-GPGSign <String>] [-NoGPGSign] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
