param(
  [int]$Port = 8000,
  [string]$Root = (Get-Location).Path
)

$prefix = "http://localhost:$Port/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Output "Serving files from: $Root"
Write-Output "Open http://localhost:$Port in your browser"

function Get-ContentType($ext){
  switch ($ext.ToLower()){
    '.html' { 'text/html' }
    '.htm'  { 'text/html' }
    '.css'  { 'text/css' }
    '.js'   { 'application/javascript' }
    '.png'  { 'image/png' }
    '.jpg'  { 'image/jpeg' }
    '.jpeg' { 'image/jpeg' }
    '.gif'  { 'image/gif' }
    '.svg'  { 'image/svg+xml' }
    '.mp3'  { 'audio/mpeg' }
    default { 'application/octet-stream' }
  }
}

try{
  while ($listener.IsListening) {
    $context = $listener.GetContext()
    try{
      $request = $context.Request
      $response = $context.Response
      $urlPath = [System.Uri]::UnescapeDataString($request.Url.AbsolutePath)
      if ($urlPath -eq '/' -or [string]::IsNullOrEmpty($urlPath)) { $urlPath = '/index.html' }
      $relPath = $urlPath.TrimStart('/') -replace '/','\\'
      $filePath = Join-Path $Root $relPath
      if (-not (Test-Path $filePath)){
        $response.StatusCode = 404
        $buffer = [System.Text.Encoding]::UTF8.GetBytes('404 - Not Found')
        $response.OutputStream.Write($buffer,0,$buffer.Length)
        $response.Close()
        continue
      }
      $ext = [System.IO.Path]::GetExtension($filePath)
      $ctype = Get-ContentType $ext
      $response.ContentType = $ctype
      $bytes = [System.IO.File]::ReadAllBytes($filePath)
      $response.ContentLength64 = $bytes.Length
      $response.OutputStream.Write($bytes,0,$bytes.Length)
      $response.OutputStream.Close()
    } catch {
      try{ $context.Response.StatusCode = 500 } catch {}
      $context.Response.Close()
    }
  }
} finally{
  if ($listener -and $listener.IsListening) { $listener.Stop() }
}
