# Script to test website functionality after optimizations

Write-Host "Starting website functionality tests..." -ForegroundColor Cyan

# Function to test a specific page
function Test-Page {
    param (
        [string]$PageName,
        [string]$FilePath
    )
    
    Write-Host "\nTesting $PageName..." -ForegroundColor Yellow
    
    # Check if file exists
    if (-not (Test-Path $FilePath)) {
        Write-Host "  ERROR: $FilePath does not exist!" -ForegroundColor Red
        return $false
    }
    
    # Read file content
    $content = Get-Content -Path $FilePath -Raw
    
    # Check for essential scripts
    $essentialScripts = @(
        "jquery",
        "bootstrap",
        "cart-sync.js"
    )
    
    $missingScripts = @()
    foreach ($script in $essentialScripts) {
        if (-not $content.Contains($script)) {
            $missingScripts += $script
        }
    }
    
    if ($missingScripts.Count -gt 0) {
        Write-Host "  WARNING: Missing essential scripts in $PageName:" -ForegroundColor Yellow
        foreach ($script in $missingScripts) {
            Write-Host "    - $script" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✓ All essential scripts present" -ForegroundColor Green
    }
    
    # Check for defer attributes (except jQuery)
    $scriptPattern = '<script\s+src="([^"]+)"[^>]*></script>'
    $matches = [regex]::Matches($content, $scriptPattern)
    
    $nonDeferredScripts = @()
    foreach ($match in $matches) {
        $scriptSrc = [regex]::Match($match.Value, 'src="([^"]+)"').Groups[1].Value
        
        # Skip jQuery
        if ($scriptSrc -match "jquery") {
            continue
        }
        
        if (-not $match.Value.Contains("defer")) {
            $nonDeferredScripts += $scriptSrc
        }
    }
    
    if ($nonDeferredScripts.Count -gt 0) {
        Write-Host "  WARNING: Scripts without defer attribute in $PageName:" -ForegroundColor Yellow
        foreach ($script in $nonDeferredScripts) {
            Write-Host "    - $script" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  ✓ All non-jQuery scripts have defer attribute" -ForegroundColor Green
    }
    
    # Check for page-specific functionality
    switch ($PageName) {
        "Index" {
            # Check for slider/banner
            if ($content.Contains("banner") -or $content.Contains("slider") -or $content.Contains("carousel")) {
                Write-Host "  ✓ Home page banner/slider present" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Home page may be missing banner/slider" -ForegroundColor Yellow
            }
        }
        "Shop" {
            # Check for product listings
            if ($content.Contains("product-item") -or $content.Contains("product-card")) {
                Write-Host "  ✓ Shop page product listings present" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Shop page may be missing product listings" -ForegroundColor Yellow
            }
        }
        "Cart" {
            # Check for cart.js
            if ($content.Contains("cart.js")) {
                Write-Host "  ✓ Cart page has cart.js script" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Cart page missing cart.js script" -ForegroundColor Yellow
            }
        }
        "Wishlist" {
            # Check for wishlist.js
            if ($content.Contains("wishlist.js")) {
                Write-Host "  ✓ Wishlist page has wishlist.js script" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Wishlist page missing wishlist.js script" -ForegroundColor Yellow
            }
        }
        "Compare" {
            # Check for compare.js
            if ($content.Contains("compare.js")) {
                Write-Host "  ✓ Compare page has compare.js script" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Compare page missing compare.js script" -ForegroundColor Yellow
            }
        }
        "Checkout" {
            # Check for checkout.js
            if ($content.Contains("checkout.js")) {
                Write-Host "  ✓ Checkout page has checkout.js script" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Checkout page missing checkout.js script" -ForegroundColor Yellow
            }
        }
        "Product" {
            # Check for product.js
            if ($content.Contains("product.js")) {
                Write-Host "  ✓ Product page has product.js script" -ForegroundColor Green
            } else {
                Write-Host "  WARNING: Product page missing product.js script" -ForegroundColor Yellow
            }
        }
    }
    
    return $true
}

# Test main pages
$pagesToTest = @{
    "Index" = "index.html";
    "Shop" = "shop.html";
    "Cart" = "cart.html";
    "Wishlist" = "wishlist.html";
    "Compare" = "compare.html";
    "Checkout" = "checkout.html";
    "Product" = "single-product.html";
}

$allPagesExist = $true
foreach ($page in $pagesToTest.GetEnumerator()) {
    $result = Test-Page -PageName $page.Key -FilePath $page.Value
    $allPagesExist = $allPagesExist -and $result
}

if ($allPagesExist) {
    Write-Host "\nAll pages exist and have been tested." -ForegroundColor Green
} else {
    Write-Host "\nSome pages are missing. Please check the errors above." -ForegroundColor Red
}

Write-Host "\nWebsite functionality tests completed." -ForegroundColor Cyan
