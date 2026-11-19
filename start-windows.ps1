$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$file = Join-Path $here 'script-booth.html'
if (-not (Test-Path $file)) { Write-Host 'script-booth.html was not found next to this script.'; Read-Host 'Press Enter'; exit 1 }
$url = 'http://localhost:8765/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()
Write-Host "Script Booth is running at $url  (close this window to stop)"
Start-Process $url
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $path = $ctx.Request.Url.AbsolutePath
  if ($path -eq '/' -or $path -eq '/script-booth.html') {
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $ctx.Response.ContentType = 'text/html; charset=utf-8'
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
  }
  $ctx.Response.OutputStream.Close()
}
