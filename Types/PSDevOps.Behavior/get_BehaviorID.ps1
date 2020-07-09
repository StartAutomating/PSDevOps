if ($this.behavior.id) {
    $this.behavior.id
} elseif ($this.url) {
    ([uri]$this.url).Segments[-1].TrimStart('/')
}
