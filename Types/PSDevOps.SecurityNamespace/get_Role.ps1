[PSCustomObject][Ordered]@{
    Read = @(
        foreach ($act in $this.Actions) {
            if ($this.readPermission -band $act.bit) {
                $act.Name
            }
        }
    )
    Write = @(
        foreach ($act in $this.Actions) {
            if ($this.writePermission -band $act.bit) {
                $act.Name
            }
        }
    )
    System = @(
        foreach ($act in $this.Actions) {
            if ($this.systemBitmask -band $act.bit) {
                $act.Name
            }
        }
    )
}


