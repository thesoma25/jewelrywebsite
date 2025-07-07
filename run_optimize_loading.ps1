# Simple script to run optimize_page_loading.ps1

Write-Host "Running page loading optimization..." -ForegroundColor Cyan

if (Test-Path "optimize_page_loading.ps1") {
    & .\optimize_page_loading.ps1
    
    if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
        Write-Host "Page loading optimization completed successfully." -ForegroundColor Green
    } else {
        Write-Host "Page loading optimization failed with exit code $LASTEXITCODE" -ForegroundColor Red
    }
} else {
    Write-Host "Script optimize_page_loading.ps1 not found." -ForegroundColor Red
}