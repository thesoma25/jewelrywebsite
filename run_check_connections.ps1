# Simple script to run check_page_connections.ps1

Write-Host "Running page connections check..." -ForegroundColor Cyan

if (Test-Path "check_page_connections.ps1") {
    & .\check_page_connections.ps1
    
    if ($LASTEXITCODE -eq 0 -or $null -eq $LASTEXITCODE) {
        Write-Host "Page connections check completed successfully." -ForegroundColor Green
    } else {
        Write-Host "Page connections check failed with exit code $LASTEXITCODE" -ForegroundColor Red
    }
} else {
    Write-Host "Script check_page_connections.ps1 not found." -ForegroundColor Red
}