Add-Git
-------
### Synopsis
PowerShell wrapper around git add

---
### Description

Adds changes to a git changelist

---
### Examples
#### EXAMPLE 1
```PowerShell
Add-Git AddGit.ps1
```

---
### Parameters
#### **Path**

The path to add to git.



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DryRun**

Don't actually add the file(s), just show if they exist and/or will
be ignored.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

Allow adding otherwise ignored files.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Interactive**

Add modified contents in the working tree interactively to
the index. Optional path arguments may be supplied to limit
operation to a subset of the working tree. See Interactive
mode for details.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Patch**

Interactively choose hunks of patch between the index and the
work tree and add them to the index. This gives the user a chance
to review the difference before adding modified contents to the
index.

This effectively runs add --interactive, but bypasses the
initial command menu and directly jumps to the patch subcommand.
See 'Interactive mode' for details.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Edit**

Open the diff vs. the index in an editor and let the user
edit it.  After the editor was closed, adjust the hunk headers
and apply the patch to the index.

The intent of this option is to pick and choose lines of the patch to
apply, or even to modify the contents of lines to be staged. This can be
quicker and more flexible than using the interactive hunk selector.
However, it is easy to confuse oneself and create a patch that does not
apply to the index. See EDITING PATCHES below.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IntentToAdd**

Record only the fact that the path will be added later. An entry
for the path is placed in the index with no content. This is
useful for, among other things, showing the unstaged content of
such files with git diff and committing them with git commit
-a.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Refresh**

Don't add the file(s), but only refresh their stat()
information in the index.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IgnoreErrors**

If some files could not be added because of errors indexing
them, do not abort the operation, but continue adding the
others. The command shall still exit with non-zero status.
The configuration variable add.ignoreErrors can be set to
true to make this the default behaviour.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **IgnoreMissing**

This option can only be used together with --dry-run. By using
this option the user can check if any of the given files would
be ignored, no matter if they are already present in the work
tree or not.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Renormalize**

Apply the "clean" process freshly to all tracked files to
forcibly add them again to the index.  This is useful after
changing core.autocrlf configuration or the text attribute
in order to correct files added with wrong CRLF/LF line endings.
This option implies -u.



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
Add-Git [-Path <String[]>] [-DryRun] [-Force] [-Interactive] [-Patch] [-Edit] [-IntentToAdd] [-Refresh] [-IgnoreErrors] [-IgnoreMissing] [-Renormalize] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
