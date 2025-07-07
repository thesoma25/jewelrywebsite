# Simple script to run ensure_consistent_navigation.ps1

Write-Host "Running navigation consistency check..." -ForegroundColor Cyan

if (Test-Path "ensure_consistent_navigation.ps1") {
    & .\ensure_consistent_navigation.ps1
    
    if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
        Write-Host "Navigation consistency check completed successfully." -ForegroundColor Green
    } else {
        Write-Host "Navigation consistency check failed with exit code $LASTEXITCODE" -ForegroundColor Red
    }
} else {
    Write-Host "Script ensure_consistent_navigation.ps1 not found." -ForegroundColor Red
}