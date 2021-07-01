if ($this.resource.downloadUrl) {
    Invoke-ADORestAPI -Uri $this.resource.downloadURL -AsByte
}
