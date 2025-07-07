# PowerShell script to ensure all pages have consistent navigation and UI elements

Write-Host "Ensuring consistent navigation and UI elements..." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Function to extract navigation from a file
function Get-Navigation {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Extract the navigation section
    if ($content -match '<header id="header".*?</header>') {
        return $matches[0]
    }
    
    return $null
}

# Function to extract footer from a file
function Get-Footer {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Extract the footer section
    if ($content -match '<footer id="footer".*?</footer>') {
        return $matches[0]
    }
    
    return $null
}

# Function to update navigation in a file
function Update-Navigation {
    param (
        [string]$FilePath,
        [string]$ReferenceNavigation
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Replace the navigation section
    if ($content -match '<header id="header".*?</header>') {
        $newContent = $content -replace '<header id="header".*?</header>', $ReferenceNavigation
        Set-Content -Path $FilePath -Value $newContent
        Write-Host "✓ Updated navigation in $FilePath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Could not find navigation section in $FilePath" -ForegroundColor Red
        return $false
    }
}

# Function to update footer in a file
function Update-Footer {
    param (
        [string]$FilePath,
        [string]$ReferenceFooter
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Replace the footer section
    if ($content -match '<footer id="footer".*?</footer>') {
        $newContent = $content -replace '<footer id="footer".*?</footer>', $ReferenceFooter
        Set-Content -Path $FilePath -Value $newContent
        Write-Host "✓ Updated footer in $FilePath" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Could not find footer section in $FilePath" -ForegroundColor Red
        return $false
    }
}

# Function to ensure all required script references are present
function Ensure-ScriptReferences {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    $modified = $false
    
    # Essential scripts that should be in all pages
    $essentialScripts = @(
        "js/jquery-1.11.0.min.js",
        "js/bootstrap.bundle.min.js",
        "js/plugins.js",
        "js/script.js",
        "js/cart-sync.js"
    )
    
    foreach ($script in $essentialScripts) {
        if ($content -notmatch [regex]::Escape($script)) {
            # Add missing script before closing body tag
            $newContent = $content -replace '</body>', "    <script src=\"$script\"></script>\n  </body>"
            $content = $newContent
            $modified = $true
            Write-Host "✓ Added missing script reference: $script to $FilePath" -ForegroundColor Green
        }
    }
    
    if ($modified) {
        Set-Content -Path $FilePath -Value $content
    }
    
    return $modified
}

# Function to ensure all required CSS references are present
function Ensure-CssReferences {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    $modified = $false
    
    # Essential CSS files that should be in all pages
    $essentialCss = @(
        "css/bootstrap.min.css",
        "style.css"
    )
    
    foreach ($css in $essentialCss) {
        if ($content -notmatch [regex]::Escape($css)) {
            # Add missing CSS before closing head tag
            $newContent = $content -replace '</head>', "    <link rel=\"stylesheet\" type=\"text/css\" href=\"$css\">\n  </head>"
            $content = $newContent
            $modified = $true
            Write-Host "✓ Added missing CSS reference: $css to $FilePath" -ForegroundColor Green
        }
    }
    
    if ($modified) {
        Set-Content -Path $FilePath -Value $content
    }
    
    return $modified
}

# Function to ensure consistent meta tags
function Ensure-MetaTags {
    param (
        [string]$FilePath
    )
    
    $content = Get-Content -Path $FilePath -Raw
    $modified = $false
    
    # Essential meta tags
    $essentialMetaTags = @(
        '<meta charset="utf-8">',
        '<meta http-equiv="X-UA-Compatible" content="IE=edge">',
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
    )
    
    foreach ($metaTag in $essentialMetaTags) {
        if ($content -notmatch [regex]::Escape($metaTag)) {
            # Add missing meta tag after opening head tag
            $newContent = $content -replace '<head>', "<head>\n    $metaTag"
            $content = $newContent
            $modified = $true
            Write-Host "✓ Added missing meta tag: $metaTag to $FilePath" -ForegroundColor Green
        }
    }
    
    if ($modified) {
        Set-Content -Path $FilePath -Value $content
    }
    
    return $modified
}

# Function to ensure consistent preloader
function Ensure-Preloader {
    param (
        [string]$FilePath,
        [string]$ReferencePreloader
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Check if preloader exists
    if ($content -notmatch '<div id="preloader">') {
        # Add preloader after opening body tag
        $newContent = $content -replace '<body>', "<body>\n    $ReferencePreloader"
        Set-Content -Path $FilePath -Value $newContent
        Write-Host "✓ Added preloader to $FilePath" -ForegroundColor Green
        return $true
    }
    
    return $false
}

# Function to ensure consistent search box
function Ensure-SearchBox {
    param (
        [string]$FilePath,
        [string]$ReferenceSearchBox
    )
    
    $content = Get-Content -Path $FilePath -Raw
    
    # Check if search box exists
    if ($content -notmatch '<div class="search-box') {
        # Add search box after preloader
        if ($content -match '</div>\s*</div>\s*</div>\s*<!-- End of preloader -->') {
            $newContent = $content -replace '(</div>\s*</div>\s*</div>\s*<!-- End of preloader -->)', "$1\n    $ReferenceSearchBox"
            Set-Content -Path $FilePath -Value $newContent
            Write-Host "✓ Added search box to $FilePath" -ForegroundColor Green
            return $true
        } else {
            # If no preloader comment, add after body tag
            $newContent = $content -replace '<body>', "<body>\n    $ReferenceSearchBox"
            Set-Content -Path $FilePath -Value $newContent
            Write-Host "✓ Added search box to $FilePath" -ForegroundColor Green
            return $true
        }
    }
    
    return $false
}

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

# Use index.html as reference for navigation and footer
$referenceFile = "index.html"
$referenceNavigation = Get-Navigation $referenceFile
$referenceFooter = Get-Footer $referenceFile

# Extract preloader and search box from reference file
$referenceContent = Get-Content -Path $referenceFile -Raw
if ($referenceContent -match '<div id="preloader".*?</div>\s*</div>\s*</div>') {
    $referencePreloader = $matches[0]
}

if ($referenceContent -match '<div class="search-box.*?</div>\s*</div>\s*</div>') {
    $referenceSearchBox = $matches[0]
}

# Process each HTML file
foreach ($file in $htmlFiles) {
    # Skip reference file
    if ($file.Name -eq $referenceFile) {
        continue
    }
    
    Write-Host "\nProcessing $($file.Name)..." -ForegroundColor Yellow
    
    # Update navigation
    $navigationUpdated = Update-Navigation $file.FullName $referenceNavigation
    
    # Update footer
    $footerUpdated = Update-Footer $file.FullName $referenceFooter
    
    # Ensure script references
    $scriptsUpdated = Ensure-ScriptReferences $file.FullName
    
    # Ensure CSS references
    $cssUpdated = Ensure-CssReferences $file.FullName
    
    # Ensure meta tags
    $metaTagsUpdated = Ensure-MetaTags $file.FullName
    
    # Ensure preloader
    $preloaderUpdated = Ensure-Preloader $file.FullName $referencePreloader
    
    # Ensure search box
    $searchBoxUpdated = Ensure-SearchBox $file.FullName $referenceSearchBox
    
    if (-not ($navigationUpdated -or $footerUpdated -or $scriptsUpdated -or $cssUpdated -or $metaTagsUpdated -or $preloaderUpdated -or $searchBoxUpdated)) {
        Write-Host "✓ No updates needed for $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "\nConsistent navigation and UI elements check completed." -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan