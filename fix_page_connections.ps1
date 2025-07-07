# Script to fix page connections and optimize loading

Write-Host "Starting page connection fixes..." -ForegroundColor Cyan

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

# Get all JS files for reference
$jsFiles = Get-ChildItem -Path . -Filter "*.js" -File | Select-Object -ExpandProperty Name

# Get all CSS files for reference
$cssFiles = Get-ChildItem -Path . -Filter "*.css" -File | Select-Object -ExpandProperty Name

# Essential JS files that should be on every page
$essentialJsFiles = @(
    "jquery-3.6.0.min.js",
    "bootstrap.bundle.min.js",
    "cart-sync.js"
)

# Essential CSS files that should be on every page
$essentialCssFiles = @(
    "bootstrap.min.css",
    "style.css"
)

# Function to ensure all essential scripts are included
function Ensure-EssentialScripts {
    param (
        [string]$htmlContent,
        [string]$fileName
    )
    
    $modified = $false
    $headEndPos = $htmlContent.IndexOf("</head>")
    
    if ($headEndPos -eq -1) {
        Write-Host "Warning: Could not find </head> tag in $fileName" -ForegroundColor Yellow
        return $htmlContent, $false
    }
    
    # Check for essential JS files
    foreach ($jsFile in $essentialJsFiles) {
        if (-not $htmlContent.Contains($jsFile)) {
            Write-Host "Adding missing script: $jsFile to $fileName" -ForegroundColor Yellow
            
            $scriptTag = "`n    <script src=`"$jsFile`" defer></script>"
            
            # Special case for jQuery - no defer
            if ($jsFile -eq "jquery-3.6.0.min.js") {
                $scriptTag = "`n    <script src=`"$jsFile`"></script>"
            }
            
            $htmlContent = $htmlContent.Insert($headEndPos, $scriptTag)
            $headEndPos += $scriptTag.Length
            $modified = $true
        }
    }
    
    # Check for essential CSS files
    foreach ($cssFile in $essentialCssFiles) {
        if (-not $htmlContent.Contains($cssFile)) {
            Write-Host "Adding missing CSS: $cssFile to $fileName" -ForegroundColor Yellow
            $linkTag = "`n    <link rel=`"stylesheet`" href=`"$cssFile`">"
            $htmlContent = $htmlContent.Insert($headEndPos, $linkTag)
            $headEndPos += $linkTag.Length
            $modified = $true
        }
    }
    
    return $htmlContent, $modified
}

# Function to add defer attribute to script tags (except jQuery)
function Add-DeferAttribute {
    param (
        [string]$htmlContent,
        [string]$fileName
    )
    
    $modified = $false
    $scriptPattern = '<script\s+src="([^"]+)"(?!\s+defer)[^>]*></script>'
    
    $matches = [regex]::Matches($htmlContent, $scriptPattern)
    
    # Process matches in reverse order to avoid index shifting
    for ($i = $matches.Count - 1; $i -ge 0; $i--) {
        $match = $matches[$i]
        $scriptSrc = [regex]::Match($match.Value, 'src="([^"]+)"').Groups[1].Value
        
        # Skip jQuery
        if ($scriptSrc -match "jquery") {
            continue
        }
        
        $newScriptTag = $match.Value.Replace('></script>', ' defer></script>')
        $htmlContent = $htmlContent.Substring(0, $match.Index) + $newScriptTag + $htmlContent.Substring($match.Index + $match.Length)
        $modified = $true
        
        Write-Host "Added defer attribute to $scriptSrc in $fileName" -ForegroundColor Yellow
    }
    
    return $htmlContent, $modified
}

# Function to ensure correct script loading order
function Ensure-ScriptOrder {
    param (
        [string]$htmlContent,
        [string]$fileName
    )
    
    $modified = $false
    
    # Ensure jQuery loads before Bootstrap
    $jqueryPattern = '<script\s+src="[^"]*jquery[^"]*\.js"[^>]*></script>'
    $bootstrapPattern = '<script\s+src="[^"]*bootstrap[^"]*\.js"[^>]*></script>'
    
    $jqueryMatch = [regex]::Match($htmlContent, $jqueryPattern)
    $bootstrapMatch = [regex]::Match($htmlContent, $bootstrapPattern)
    
    if ($jqueryMatch.Success -and $bootstrapMatch.Success) {
        if ($bootstrapMatch.Index < $jqueryMatch.Index) {
            # Need to reorder - remove both and add in correct order
            $htmlContent = $htmlContent.Remove($bootstrapMatch.Index, $bootstrapMatch.Length)
            
            # Recalculate jQuery position after removing Bootstrap
            $jqueryMatch = [regex]::Match($htmlContent, $jqueryPattern)
            
            # Insert Bootstrap after jQuery
            $htmlContent = $htmlContent.Insert($jqueryMatch.Index + $jqueryMatch.Length, "`n    " + $bootstrapMatch.Value)
            $modified = $true
            
            Write-Host "Reordered jQuery and Bootstrap in $fileName" -ForegroundColor Yellow
        }
    }
    
    # Ensure cart-sync.js loads before other cart-related scripts
    $cartSyncPattern = '<script\s+src="[^"]*cart-sync\.js"[^>]*></script>'
    $cartPattern = '<script\s+src="[^"]*cart\.js"[^>]*></script>'
    
    $cartSyncMatch = [regex]::Match($htmlContent, $cartSyncPattern)
    $cartMatch = [regex]::Match($htmlContent, $cartPattern)
    
    if ($cartSyncMatch.Success -and $cartMatch.Success) {
        if ($cartMatch.Index < $cartSyncMatch.Index) {
            # Need to reorder - remove both and add in correct order
            $htmlContent = $htmlContent.Remove($cartMatch.Index, $cartMatch.Length)
            
            # Recalculate cartSync position after removing cart
            $cartSyncMatch = [regex]::Match($htmlContent, $cartSyncPattern)
            
            # Insert cart after cartSync
            $htmlContent = $htmlContent.Insert($cartSyncMatch.Index + $cartSyncMatch.Length, "`n    " + $cartMatch.Value)
            $modified = $true
            
            Write-Host "Reordered cart-sync.js and cart.js in $fileName" -ForegroundColor Yellow
        }
    }
    
    return $htmlContent, $modified
}

# Function to ensure navigation links are consistent
function Ensure-NavigationLinks {
    param (
        [string]$htmlContent,
        [string]$fileName
    )
    
    $modified = $false
    $essentialPages = @(
        "index.html",
        "shop.html",
        "cart.html",
        "wishlist.html",
        "compare.html",
        "checkout.html",
        "contact.html"
    )
    
    # Extract navigation section
    $navPattern = '<nav\s+[^>]*>.*?</nav>'
    $navMatch = [regex]::Match($htmlContent, $navPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    
    if (-not $navMatch.Success) {
        Write-Host "Warning: Could not find navigation section in $fileName" -ForegroundColor Yellow
        return $htmlContent, $false
    }
    
    $navContent = $navMatch.Value
    
    # Check for missing page links
    foreach ($page in $essentialPages) {
        if (-not $navContent.Contains("href=`"$page`"")) {
            Write-Host "Warning: Link to $page missing in navigation of $fileName" -ForegroundColor Yellow
            # We would fix this, but it requires more complex HTML parsing to do properly
            # For now, just flag it as an issue
        }
    }
    
    return $htmlContent, $modified
}

# Process each HTML file
foreach ($file in $htmlFiles) {
    $fileName = $file.Name
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    $modified = $false
    
    Write-Host "Processing $fileName..." -ForegroundColor Cyan
    
    # Apply fixes
    $content, $scriptsModified = Ensure-EssentialScripts -htmlContent $content -fileName $fileName
    $modified = $modified -or $scriptsModified
    
    $content, $deferModified = Add-DeferAttribute -htmlContent $content -fileName $fileName
    $modified = $modified -or $deferModified
    
    $content, $orderModified = Ensure-ScriptOrder -htmlContent $content -fileName $fileName
    $modified = $modified -or $orderModified
    
    $content, $navModified = Ensure-NavigationLinks -htmlContent $content -fileName $fileName
    $modified = $modified -or $navModified
    
    # Save changes if modified
    if ($modified) {
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Updated $fileName" -ForegroundColor Green
    } else {
        Write-Host "No changes needed for $fileName" -ForegroundColor Green
    }
}

Write-Host "\nPage connection fixes completed." -ForegroundColor Green