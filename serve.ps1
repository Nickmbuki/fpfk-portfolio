param(
  [int]$Port = 8000
)

# Start a simple HTTP server and open the site in the default browser
Push-Location -Path "$PSScriptRoot"
try{
  Write-Output "Starting Python HTTP server on port $Port in $PWD"
  Start-Process -FilePath "python" -ArgumentList "-m http.server $Port" -WorkingDirectory $PWD
  Start-Sleep -Seconds 1
  Start-Process "http://localhost:$Port"
} finally{
  Pop-Location
}
