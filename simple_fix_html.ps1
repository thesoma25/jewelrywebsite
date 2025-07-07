# Simple script to fix HTML files

Write-Host "Starting simple HTML fixes..." -ForegroundColor Cyan

# Get all HTML files
$htmlFiles = Get-ChildItem -Path . -Filter "*.html" -File

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

# Process each HTML file
foreach ($file in $htmlFiles) {
    $fileName = $file.Name
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content
    $modified = $false
    
    Write-Host "Processing $fileName..." -ForegroundColor Cyan
    
    # Check for </head> tag
    $headEndPos = $content.IndexOf("</head>")
    
    if ($headEndPos -eq -1) {
        Write-Host "Warning: Could not find </head> tag in $fileName" -ForegroundColor Yellow
        continue
    }
    
    # Check for essential JS files
    foreach ($jsFile in $essentialJsFiles) {
        if (-not $content.Contains($jsFile)) {
            Write-Host "Adding missing script: $jsFile to $fileName" -ForegroundColor Yellow
            
            $scriptTag = "`n    <script src=`"$jsFile`" defer></script>"
            
            # Special case for jQuery - no defer
            if ($jsFile -eq "jquery-3.6.0.min.js") {
                $scriptTag = "`n    <script src=`"$jsFile`"></script>"
            }
            
            $content = $content.Insert($headEndPos, $scriptTag)
            $headEndPos += $scriptTag.Length
            $modified = $true
        }
    }
    
    # Check for essential CSS files
    foreach ($cssFile in $essentialCssFiles) {
        if (-not $content.Contains($cssFile)) {
            Write-Host "Adding missing CSS: $cssFile to $fileName" -ForegroundColor Yellow
            $linkTag = "`n    <link rel=`"stylesheet`" href=`"$cssFile`">"
            $content = $content.Insert($headEndPos, $linkTag)
            $headEndPos += $linkTag.Length
            $modified = $true
        }
    }
    
    # Add defer attribute to script tags (except jQuery)
    $newContent = ""
    $currentPos = 0
    
    # Find all script tags with src attribute
    $scriptPattern = '<script\s+src="([^"]+)"(?!\s+defer)[^>]*></script>'
    $matches = [regex]::Matches($content, $scriptPattern)
    
    foreach ($match in $matches) {
        $scriptSrc = [regex]::Match($match.Value, 'src="([^"]+)"').Groups[1].Value
        
        # Skip jQuery
        if ($scriptSrc -match "jquery") {
            continue
        }
        
        # Add text before this match
        $newContent += $content.Substring($currentPos, $match.Index - $currentPos)
        
        # Add modified script tag with defer
        $newScriptTag = $match.Value.Replace('></script>', ' defer></script>')
        $newContent += $newScriptTag
        
        # Update current position
        $currentPos = $match.Index + $match.Length
        
        $modified = $true
        Write-Host "Added defer attribute to $scriptSrc in $fileName" -ForegroundColor Yellow
    }
    
    # Add remaining content
    if ($currentPos -lt $content.Length) {
        $newContent += $content.Substring($currentPos)
    }
    
    # Only update content if we made script tag changes
    if ($newContent -ne "") {
        $content = $newContent
    }
    
    # Save changes if modified
    if ($modified) {
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Updated $fileName" -ForegroundColor Green
    } else {
        Write-Host "No changes needed for $fileName" -ForegroundColor Green
    }
}

Write-Host "\nSimple HTML fixes completed." -ForegroundColor Green