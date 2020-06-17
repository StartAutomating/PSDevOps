<#
.Synopsis
    Dequeues input
.Description
    Dequeues input and assigns each input to a value.

    This function must part must be dot-sourced.
#>
param(
[Parameter(Mandatory,Position=0)]
$InputQueue
)

if (-not $InputQueue.Dequeue) { Write-Error "Not a Queue"; return }
$DequedInput = [Collections.IDictionary]$InputQueue.Dequeue()
if ($DequedInput) {
    foreach ($kv in $DequedInput.GetEnumerator()) {
        $ExecutionContext.SessionState.PSVariable.Set($kv.Key, $kv.Value)
    }
}
