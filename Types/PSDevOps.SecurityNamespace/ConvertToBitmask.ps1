param(
[Parameter(Mandatory,Position=0)]
[string[]]
$Permission
)

$bitMask = 0

foreach ($act in $this.Actions) {
    foreach ($p in $Permission) {
        if ($act.Name -like $p -or $act.DisplayName -like $p) {
            $bitMask = $bitmask -bor $act.bit
        }
    }
}
$bitMask
