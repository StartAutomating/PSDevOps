param(
[Parameter(ValueFromPipeline,Position=0)]$Object,
[Object]$Parent,
[Object]$GrandParent,
[int]$Indent = 0)

begin { $n = 0; $mySelf = $myInvocation.MyCommand.ScriptBlock }
process {
    $n++
    if ($Object -eq $null) { return }

    if ($Parent -and $Parent -is [Collections.IList]) {
        if ($Parent.IndexOf($Object) -gt 0) { ' ' * $Indent }
        '- '
    }

    #region Primitives
    if ( $Object -is [string] ) { # If it's a string
        if ($object -match '\n') { # see if it's a multline string.
            "|" # If it is, emit the multiline indicator
            $indent+=2
            foreach ($l in $object -split '(?>\r\n|\n)') { # and emit each line indented
                [Environment]::NewLine
                ' ' * $indent
                $l
            }
            $indent-=2
        } elseif ("$object".Contains('*')) {
            "'$($Object -replace "'","''")'"
        } else {
            $object
        }

        if ($Parent -is [Collections.IList]) { # If the parent object was a list
            [Environment]::NewLine # emit a newline.
        }
        return # Once the string has been emitted, return.
    }
    if ( [int], [float], [bool] -contains $Object.GetType() ) { # If it is an [int] or [float] or [bool]
        "$Object".ToLower()  # Emit it in lowercase.
        if ($Parent -is [Collections.IList]) {
            [Environment]::NewLine
        }
        return
    }
    #endregion Primitives

    #region KVP
    if ( $Object -is [Collections.DictionaryEntry] -or $object -is [Management.Automation.PSPropertyInfo]) {
        if ($Parent -isnot [Collections.IList] -and
            ($GrandParent -isnot [Collections.IList] -or $n -gt 1)) {
            [Environment]::NewLine + (" " * $Indent)
        }
        if ($object.Key -and $Object.Key -is [string]) {
            $Object.Key +": "
        } elseif ($object.Name -and $object.Name -is [string]) {
            $Object.Name +": "
        }
    }

    if ( $Object -is [Collections.DictionaryEntry] -or $Object -is [Management.Automation.PSPropertyInfo]) {
        & $mySelf -Object $Object.Value -Parent $Object -GrandParent $parent -Indent $Indent
        return
    }
    #endregion KVP


    #region Nested
    if ($Object -is [Collections.IDictionary] -or $Object  -is [PSObject]) {
        $Indent += 2
    } 
    elseif ($object -is [Collections.IList]) {
        $allPrimitive = 1
        foreach ($Obj in $Object) { 
            $allPrimitive = $allPrimitive -band (
                $Obj -is [string] -or 
                $obj -is [int] -or 
                $obj -is [float] -or 
                $obj -is [bool]
            ) 
        }
        if (-not $allPrimitive) {
            $Indent += 2
        }            
    }


    if ( $Object -is [Collections.IDictionary] ) {
        $Object.GetEnumerator() |
            & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent
    } elseif ($Object -is [Collections.IList]) {

        [Environment]::NewLine + (' ' * $Indent)

        $Object |
            & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent

    } elseif ($Object.PSObject.Properties) {
        $Object.psobject.properties |
            & $mySelf -Parent $Object -GrandParent $Parent -Indent $Indent
    }

    if ($Object -is [Collections.IDictionary] -or $Object  -is [PSCustomObject] -or $Object -is [Collections.IList]) {
        if ($Parent -is [Collections.IList]) { [Environment]::NewLine }
        $Indent -= 2;
    }
    #endregion Nested
}
