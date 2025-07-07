# PowerShell script to open cart.html in the default browser

$filePath = Join-Path -Path $PSScriptRoot -ChildPath "cart.html"

Write-Host "Attempting to open: $filePath"

try {
    # Try using Invoke-Item (works in most cases)
    Invoke-Item $filePath
    Write-Host "Browser opened successfully!"
} catch {
    Write-Host "First method failed, trying alternative..."
    
    try {
        # Alternative method using Start-Process
        Start-Process $filePath
        Write-Host "Browser opened successfully with alternative method!"
    } catch {
        Write-Host "Error opening browser: $_"
    }
}