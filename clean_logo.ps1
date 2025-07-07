# PowerShell script to remove newline characters from the header logo in all HTML files

# Get all HTML files in the directory
$htmlFiles = Get-ChildItem -Path . -Filter *.html -Recurse

# Process each HTML file
foreach ($file in $htmlFiles) {
    Write-Host "Processing $($file.FullName)..."
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace the navbar-brand with newlines with a clean version
    $cleanedContent = $content -replace '<a class="navbar-brand" href="index.html">\n                <h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1>\n              </a>', '<a class="navbar-brand" href="index.html"><h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1></a>'
    
    # Replace the offcanvas-header navbar-brand with newlines with a clean version
    $cleanedContent = $cleanedContent -replace '<a class="navbar-brand" href="index.html">\n                <h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1>\n              </a>', '<a class="navbar-brand" href="index.html"><h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1></a>'
    
    # Try a more aggressive approach for files that weren't properly cleaned
    $cleanedContent = $cleanedContent -replace '(<a class="navbar-brand" href="index.html">)\\n\s*(<h1 style="font-family: ''Eagle Lake'', cursive; font-size: 28px; margin: 0;">Marquise Maison</h1>)\\n\s*</a>', '$1$2</a>'
    
    # Write the cleaned content back to the file
    Set-Content -Path $file.FullName -Value $cleanedContent
}

Write-Host "All HTML files have been cleaned successfully!"