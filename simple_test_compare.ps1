# Simple script to test compare functionality

Write-Host "Testing compare functionality..." -ForegroundColor Cyan

# Check if compare.js exists
if (Test-Path "js\compare.js") {
    Write-Host "✓ compare.js file exists" -ForegroundColor Green
} else {
    Write-Host "✗ compare.js file not found!" -ForegroundColor Red
    exit 1
}

# Check if compare.html exists
if (Test-Path "compare.html") {
    Write-Host "✓ compare.html file exists" -ForegroundColor Green
} else {
    Write-Host "✗ compare.html file not found!" -ForegroundColor Red
    exit 1
}

# Read compare.js content
$compareJsContent = Get-Content -Path "js\compare.js" -Raw

# Check for key functions
$requiredFunctions = @(
    "addToCompare",
    "removeFromCompare",
    "clearCompare",
    "loadCompareData",
    "updateCompareCount",
    "getCompareData"
)

$missingFunctions = @()
foreach ($function in $requiredFunctions) {
    if (-not $compareJsContent.Contains($function)) {
        $missingFunctions += $function
    }
}

if ($missingFunctions.Count -gt 0) {
    Write-Host "WARNING: Missing functions in compare.js:" -ForegroundColor Yellow
    foreach ($function in $missingFunctions) {
        Write-Host "  - $function" -ForegroundColor Yellow
    }
} else {
    Write-Host "✓ All required functions found in compare.js" -ForegroundColor Green
}

# Read compare.html content
$compareHtmlContent = Get-Content -Path "compare.html" -Raw

# Check if compare.js is included in compare.html
if ($compareHtmlContent.Contains("compare.js")) {
    Write-Host "✓ compare.js is included in compare.html" -ForegroundColor Green
} else {
    Write-Host "✗ compare.js is not included in compare.html!" -ForegroundColor Red
}

# Check if compare.html has the necessary structure
if ($compareHtmlContent.Contains("compare-table") -or $compareHtmlContent.Contains("comparison-table")) {
    Write-Host "✓ compare.html contains comparison table structure" -ForegroundColor Green
} else {
    Write-Host "WARNING: compare.html may be missing comparison table structure" -ForegroundColor Yellow
}

# Check if cart-sync.js is included before compare.js
$cartSyncIndex = $compareHtmlContent.IndexOf("cart-sync.js")
$compareJsIndex = $compareHtmlContent.IndexOf("compare.js")

if ($cartSyncIndex -ne -1 -and $compareJsIndex -ne -1) {
    if ($cartSyncIndex -lt $compareJsIndex) {
        Write-Host "✓ cart-sync.js is loaded before compare.js" -ForegroundColor Green
    } else {
        Write-Host "WARNING: cart-sync.js should be loaded before compare.js" -ForegroundColor Yellow
    }
} else {
    if ($cartSyncIndex -eq -1) {
        Write-Host "✗ cart-sync.js is not included in compare.html!" -ForegroundColor Red
    }
}

# Check if compare functionality is referenced in other pages
$otherPages = @(
    "index.html",
    "shop.html",
    "single-product.html"
)

$pagesWithCompareReference = @()
foreach ($page in $otherPages) {
    if (Test-Path $page) {
        $content = Get-Content -Path $page -Raw
        if ($content.Contains("compare.js") -or $content.Contains("addToCompare")) {
            $pagesWithCompareReference += $page
        }
    }
}

if ($pagesWithCompareReference.Count -gt 0) {
    Write-Host "✓ Compare functionality is referenced in:" -ForegroundColor Green
    foreach ($page in $pagesWithCompareReference) {
        Write-Host "  - $page" -ForegroundColor Green
    }
} else {
    Write-Host "WARNING: Compare functionality may not be referenced in other pages" -ForegroundColor Yellow
}

Write-Host "\nCompare functionality test completed." -ForegroundColor Cyan