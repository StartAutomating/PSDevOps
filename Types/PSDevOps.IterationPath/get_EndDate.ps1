if ($this.Attributes.FinishDate) {
    ($this.Attributes.FinishDate -as [DateTime]).ToUniversalTime()
}
