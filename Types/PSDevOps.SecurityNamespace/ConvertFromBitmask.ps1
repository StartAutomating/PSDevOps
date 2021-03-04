param(
[int]
$Bitmask
)


@(foreach ($act in $this.Actions) {
    if ($Bitmask -band $act.bit) {
        $act.Name
    }    
})


