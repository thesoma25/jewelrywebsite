# PowerShell script to optimize page loading and ensure JavaScript files are properly loaded

Write-Host "Optimizing page loading..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Function to check if a file exists
function Test-FileExists {
    param (
        [string]$FilePath
    )
    
    if (Test-Path $FilePath) {
        return $true
    } else {
        return $false
    }
}

# Function to add defer attribute to script tags
function Add-DeferAttribute {
    param (
        [string]$HtmlFile
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    $modified = $false
    
    # Add defer attribute to script tags that don't have it
    # Exclude jQuery as it might be needed immediately
    if ($content -match '<script src="[^"]*\.js"[^>]*>') {
        $newContent = $content -replace '(<script src="(?!.*jquery).*\.js")([^>]*)(>)', '$1$2 defer$3'
        
        if ($newContent -ne $content) {
            $modified = $true
            Set-Content -Path $HtmlFile -Value $newContent
            Write-Host "✓ Added defer attribute to script tags in $HtmlFile" -ForegroundColor Green
        } else {
            Write-Host "✓ Script tags already have defer attribute in $HtmlFile" -ForegroundColor Green
        }
    }
    
    return $modified
}

# Function to ensure cart-sync.js is loaded before other cart-related scripts
function Optimize-ScriptOrder {
    param (
        [string]$HtmlFile
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    $modified = $false
    
    # Check if cart-sync.js is loaded before cart.js, wishlist.js, and compare.js
    if ($content -match '<script src="js/cart\.js"') {
        if ($content -match '<script src="js/cart-sync\.js".*?<script src="js/cart\.js"') {
            Write-Host "✓ cart-sync.js is loaded before cart.js in $HtmlFile" -ForegroundColor Green
        } else {
            # Reorder scripts to ensure cart-sync.js is loaded first
            $newContent = $content -replace '(<script src="js/cart\.js"[^>]*>)', '<script src="js/cart-sync.js"></script>\n    $1'
            $newContent = $newContent -replace '<script src="js/cart-sync\.js"></script>\s*<script src="js/cart-sync\.js"></script>', '<script src="js/cart-sync.js"></script>'
            
            if ($newContent -ne $content) {
                $modified = $true
                Set-Content -Path $HtmlFile -Value $newContent
                Write-Host "✓ Reordered scripts to load cart-sync.js before cart.js in $HtmlFile" -ForegroundColor Green
            }
        }
    }
    
    return $modified
}

# Function to ensure jQuery is loaded before Bootstrap and other scripts
function Ensure-JQueryFirst {
    param (
        [string]$HtmlFile
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    $modified = $false
    
    # Check if jQuery is loaded before Bootstrap
    if ($content -match '<script src="[^"]*jquery[^"]*\.js".*?<script src="[^"]*bootstrap[^"]*\.js"') {
        Write-Host "✓ jQuery is loaded before Bootstrap in $HtmlFile" -ForegroundColor Green
    } else if ($content -match '<script src="[^"]*bootstrap[^"]*\.js"' -and $content -match '<script src="[^"]*jquery[^"]*\.js"') {
        # Reorder scripts to ensure jQuery is loaded first
        $jqueryScript = [regex]::Match($content, '<script src="[^"]*jquery[^"]*\.js"[^>]*>').Value
        $newContent = $content -replace '<script src="[^"]*jquery[^"]*\.js"[^>]*>', ''
        $newContent = $newContent -replace '(<script src="[^"]*bootstrap[^"]*\.js"[^>]*>)', "$jqueryScript\n    `$1"
        
        if ($newContent -ne $content) {
            $modified = $true
            Set-Content -Path $HtmlFile -Value $newContent
            Write-Host "✓ Reordered scripts to load jQuery before Bootstrap in $HtmlFile" -ForegroundColor Green
        }
    }
    
    return $modified
}

# Function to ensure all required scripts are included
function Ensure-RequiredScripts {
    param (
        [string]$HtmlFile
    )
    
    $content = Get-Content -Path $HtmlFile -Raw
    $modified = $false
    $fileName = Split-Path $HtmlFile -Leaf
    
    # Essential scripts for all pages
    $essentialScripts = @(
        "js/jquery-1.11.0.min.js",
        "js/bootstrap.bundle.min.js",
        "js/script.js",
        "js/cart-sync.js"
    )
    
    # Page-specific scripts
    $pageSpecificScripts = @{}
    $pageSpecificScripts["cart.html"] = @("js/cart.js")
    $pageSpecificScripts["wishlist.html"] = @("js/wishlist.js")
    $pageSpecificScripts["compare.html"] = @("js/compare.js")
    $pageSpecificScripts["single-product.html"] = @("js/product.js")
    
    # Check essential scripts
    foreach ($script in $essentialScripts) {
        if ($content -notmatch [regex]::Escape($script)) {
            # Add missing script before closing body tag
            $newContent = $content -replace '</body>', "    <script src=\"$script\"></script>\n  </body>"
            $content = $newContent
            $modified = $true
            Write-Host "✓ Added missing script $script to $HtmlFile" -ForegroundColor Green
        }
    }
    
    # Check page-specific scripts
    if ($pageSpecificScripts.ContainsKey($fileName)) {
        foreach ($script in $pageSpecificScripts[$fileName]) {
            if ($content -notmatch [regex]::Escape($script)) {
                # Add missing script before closing body tag
                $newContent = $content -replace '</body>', "    <script src=\"$script\"></script>\n  </body>"
                $content = $newContent
                $modified = $true
                Write-Host "✓ Added missing page-specific script $script to $HtmlFile" -ForegroundColor Green
            }
        }
    }
    
    if ($modified) {
        Set-Content -Path $HtmlFile -Value $content
    }
    
    return $modified
}

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

# Process each HTML file
foreach ($file in $htmlFiles) {
    Write-Host "\nProcessing $($file.Name)..." -ForegroundColor Yellow
    
    # Ensure all required scripts are included
    $scriptsAdded = Ensure-RequiredScripts $file.FullName
    
    # Add defer attribute to script tags
    $deferAdded = Add-DeferAttribute $file.FullName
    
    # Optimize script order
    $orderOptimized = Optimize-ScriptOrder $file.FullName
    
    # Ensure jQuery is loaded before Bootstrap
    $jqueryOptimized = Ensure-JQueryFirst $file.FullName
    
    if (-not ($scriptsAdded -or $deferAdded -or $orderOptimized -or $jqueryOptimized)) {
        Write-Host "✓ No optimizations needed for $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "\nPage loading optimization completed." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Create a test script to verify page loading speed
$testScriptContent = @"
# PowerShell script to test page loading speed

Write-Host "Testing page loading speed..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Function to open a page and measure loading time
function Test-PageLoadingSpeed {
    param (
        [string]`$PagePath
    )
    
    `$fileName = Split-Path `$PagePath -Leaf
    Write-Host "Testing loading speed for `$fileName..." -ForegroundColor Yellow
    
    # Start timing
    `$startTime = Get-Date
    
    # Open the page in default browser
    Start-Process `$PagePath
    
    # Wait a bit for the page to start loading
    Start-Sleep -Seconds 1
    
    # End timing (this is approximate since we can't hook into the browser's load event)
    `$endTime = Get-Date
    `$loadTime = (`$endTime - `$startTime).TotalSeconds
    
    Write-Host "Approximate loading time for `$fileName: `$loadTime seconds" -ForegroundColor Green
    
    # Wait before testing the next page
    Start-Sleep -Seconds 3
}

# Test essential pages
Test-PageLoadingSpeed "index.html"
Test-PageLoadingSpeed "cart.html"
Test-PageLoadingSpeed "wishlist.html"
Test-PageLoadingSpeed "compare.html"
Test-PageLoadingSpeed "single-product.html"

Write-Host "\nPage loading speed test completed." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
"@

# Save the test script
$testScriptPath = "test_page_loading_speed.ps1"
Set-Content -Path $testScriptPath -Value $testScriptContent

Write-Host "\nCreated test script: $testScriptPath" -ForegroundColor Green
Write-Host "Run this script to test page loading speed after optimizations." -ForegroundColor Green