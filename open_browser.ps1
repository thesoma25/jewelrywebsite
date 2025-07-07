# PowerShell script to open index.html in the default browser

$filePath = Join-Path -Path $PWD.Path -ChildPath "index.html"

# Convert to absolute path
$absolutePath = [System.IO.Path]::GetFullPath($filePath)

Write-Host "Attempting to open: $absolutePath"

# Use Start-Process with the file path
try {
    Start-Process $absolutePath
    Write-Host "Browser opened successfully!"
} catch {
    Write-Host "Error opening browser: $_"
    
    # Try alternative method
    Write-Host "Trying alternative method..."
    try {
        Invoke-Item $absolutePath
        Write-Host "Alternative method successful!"
    } catch {
        Write-Host "Alternative method failed: $_"
    }
}