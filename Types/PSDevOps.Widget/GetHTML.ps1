if (-not $this.contentUri) { throw '$this.ContentUri is empty' }
return Invoke-RestMethod $this.contentUri
