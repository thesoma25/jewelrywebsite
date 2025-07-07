# PowerShell script to add cart-sync.js to all HTML files

Write-Host "Adding cart-sync.js to all HTML files..." -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Get all HTML files in the current directory
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

# Output all HTML files found
Write-Host "All HTML files in directory:" -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "  - $($file.Name)"
}

# Files that have already been updated
$updatedFiles = @(
    "cart.html",
    "single-product.html",
    "profile.html",
    "index.html",
    "checkout.html"
)

# Counter for updated files
$updatedCount = 0
$skippedCount = 0
$errorCount = 0

# List all HTML files found
Write-Host "Found $($htmlFiles.Count) HTML files:" -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "  - $($file.Name)"
}
Write-Host ""

foreach ($file in $htmlFiles) {
    Write-Host "Processing $($file.Name)..." -NoNewline
    
    # Skip files that have already been updated manually
    if ($updatedFiles -contains $file.Name) {
        Write-Host "SKIPPED (already updated manually)" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    $content = Get-Content -Path $file.FullName -Raw
    
    # Check if the file already contains cart-sync.js
    if ($content -match "cart-sync\.js") {
        Write-Host "SKIPPED (already contains cart-sync.js)" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    # Find the position to insert the cart-sync.js script
    # Look for the last script tag before the closing body tag
    if ($content -match "(\s*<script[^>]*>.*?</script>\s*)(\s*</body>)") {
        $scriptTag = "`n    <script src=`"js/cart-sync.js`"></script>"
        $newContent = $content -replace "(\s*<script[^>]*>.*?</script>\s*)(\s*</body>)", "$1$scriptTag$2"
        
        # Write the updated content back to the file
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        
        Write-Host "UPDATED" -ForegroundColor Green
        $updatedCount++
    } else {
        Write-Host "ERROR (could not find insertion point)" -ForegroundColor Red
        Write-Host "  - File structure issue: $($file.Name) doesn't have a proper script tag followed by </body> tag" -ForegroundColor Red
        $global:errorFile = $file.Name
        $errorCount++
    }
}

Write-Host "\nSummary:" -ForegroundColor Cyan
Write-Host "=======" -ForegroundColor Cyan
Write-Host "Total HTML files: $($htmlFiles.Count)" -ForegroundColor White
Write-Host "Updated: $updatedCount" -ForegroundColor Green
Write-Host "Skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "Errors: $errorCount" -ForegroundColor Red
Write-Host "\nFiles already updated manually: $($updatedFiles.Count)" -ForegroundColor White
foreach ($file in $updatedFiles) {
    Write-Host "  - $file" -ForegroundColor Gray
}

if ($errorCount -gt 0) {
    Write-Host "\nFiles with errors:" -ForegroundColor Red
    Write-Host "  - $global:errorFile" -ForegroundColor Red
}