# PowerShell script to update all HTML files
# Add Eagle Lake font and replace logo with text

$htmlFiles = Get-ChildItem -Path "$PSScriptRoot" -Filter "*.html"

foreach ($file in $htmlFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    
    # 1. Add Eagle Lake font
    $content = $content -replace '<link href="https://fonts\.googleapis\.com/css2\?family=Cormorant\+Upright:wght@300;400;500;600;700&family=Sofia\+Sans:ital,wght@0,1\.\.1000;1,1\.\.1000&display=swap" rel="stylesheet">', '<link href="https://fonts.googleapis.com/css2?family=Cormorant+Upright:wght@300;400;500;600;700&family=Eagle+Lake&family=Sofia+Sans:ital,wght@0,1..1000;1,1..1000&display=swap" rel="stylesheet">'
    
    # 2. Replace logo in header with text
    $content = $content -replace '<a class="navbar-brand" href="index\.html"[^>]*>\s*<img src="images/main-logo\.png" class="logo">\s*</a>', '<a class="navbar-brand" href="index.html">\n                <h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1>\n              </a>'
    
    # 3. Replace logo in mobile menu with text
    $content = $content -replace '<a class="navbar-brand" href="index\.html" data-aos="zoom-in" data-aos-delay="300">\s*<img src="images/main-logo\.png" class="logo">\s*</a>', '<a class="navbar-brand" href="index.html" data-aos="zoom-in" data-aos-delay="300">\n            <h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1>\n          </a>'
    
    # 4. Replace logo in footer with text
    $content = $content -replace '<img src="images/main-logo\.png" alt="logo"[^>]*>', '<h2 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin-bottom: 15px;">Marquise Maison</h2>'
    
    # 5. Update page titles
    $content = $content -replace '<title>(.*?)</title>', '<title>Marquise Maison - Luxury Jewelry and Accessories</title>'
    
    # Save the modified content back to the file
    Set-Content -Path $file.FullName -Value $content
}

Write-Host "All HTML files have been updated successfully!"