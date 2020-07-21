if ($this.Attributes.StartDate) {
    ($this.Attributes.StartDate -as [DateTime]).ToUniversalTime()
}