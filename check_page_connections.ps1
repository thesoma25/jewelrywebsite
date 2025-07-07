# PowerShell script to check all page connections and ensure they load quickly

Write-Host "Checking all page connections..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Function to check if a file exists
function Test-FileExists {
    param (
        [string]$FilePath
    )
    
    if (Test-Path $FilePath) {
        Write-Host "✓ File exists: $FilePath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ File missing: $FilePath" -ForegroundColor Red
        return $false
    }
}

# Function to check if a script reference exists in HTML file
function Test-ScriptReference {
    param (
        [string]$HtmlFile,
        [string]$ScriptPath
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    if ($content -match [regex]::Escape($ScriptPath)) {
        Write-Host "✓ Script reference found in $HtmlFile: $ScriptPath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Script reference missing in $HtmlFile: $ScriptPath" -ForegroundColor Red
        return $false
    }
}

# Function to check if a CSS reference exists in HTML file
function Test-CssReference {
    param (
        [string]$HtmlFile,
        [string]$CssPath
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    if ($content -match [regex]::Escape($CssPath)) {
        Write-Host "✓ CSS reference found in $HtmlFile: $CssPath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ CSS reference missing in $HtmlFile: $CssPath" -ForegroundColor Red
        return $false
    }
}

# Function to check navigation links in HTML file
function Test-NavigationLinks {
    param (
        [string]$HtmlFile
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    $missingLinks = @()
    
    # List of essential pages to check
    $essentialPages = @(
        "index.html",
        "cart.html",
        "checkout.html",
        "wishlist.html",
        "compare.html",
        "single-product.html"
    )
    
    foreach ($page in $essentialPages) {
        if ($content -match [regex]::Escape("href=\"$page\"")) {
            Write-Host "✓ Link found in $HtmlFile: $page" -ForegroundColor Green
        } else {
            Write-Host "✗ Link missing in $HtmlFile: $page" -ForegroundColor Red
            $missingLinks += $page
        }
    }
    
    return $missingLinks
}

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

# Check essential files
Write-Host "\nChecking essential files..." -ForegroundColor Cyan
Test-FileExists "index.html"
Test-FileExists "cart.html"
Test-FileExists "checkout.html"
Test-FileExists "wishlist.html"
Test-FileExists "compare.html"
Test-FileExists "single-product.html"

# Check essential JavaScript files
Write-Host "\nChecking essential JavaScript files..." -ForegroundColor Cyan
Test-FileExists "js\script.js"
Test-FileExists "js\cart.js"
Test-FileExists "js\cart-sync.js"
Test-FileExists "js\wishlist.js"
Test-FileExists "js\compare.js"

# Check essential CSS files
Write-Host "\nChecking essential CSS files..." -ForegroundColor Cyan
Test-FileExists "css\bootstrap.min.css"
Test-FileExists "style.css"

# Check script references in HTML files
Write-Host "\nChecking script references in HTML files..." -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "\nChecking script references in $($file.Name)..." -ForegroundColor Yellow
    Test-ScriptReference $file.FullName "js/script.js"
    
    # Check for cart-sync.js in all pages
    Test-ScriptReference $file.FullName "js/cart-sync.js"
    
    # Check for specific scripts in relevant pages
    if ($file.Name -eq "cart.html") {
        Test-ScriptReference $file.FullName "js/cart.js"
    }
    
    if ($file.Name -eq "wishlist.html") {
        Test-ScriptReference $file.FullName "js/wishlist.js"
    }
    
    if ($file.Name -eq "compare.html") {
        Test-ScriptReference $file.FullName "js/compare.js"
    }
}

# Check CSS references in HTML files
Write-Host "\nChecking CSS references in HTML files..." -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "\nChecking CSS references in $($file.Name)..." -ForegroundColor Yellow
    Test-CssReference $file.FullName "css/bootstrap.min.css"
    Test-CssReference $file.FullName "style.css"
}

# Check navigation links in HTML files
Write-Host "\nChecking navigation links in HTML files..." -ForegroundColor Cyan
foreach ($file in $htmlFiles) {
    Write-Host "\nChecking navigation links in $($file.Name)..." -ForegroundColor Yellow
    $missingLinks = Test-NavigationLinks $file.FullName
    
    if ($missingLinks.Count -eq 0) {
        Write-Host "All essential navigation links found in $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "\nPage connection check completed." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan