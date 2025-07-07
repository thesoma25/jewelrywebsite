# Test script to open the website and check for errors

$indexPath = "$PSScriptRoot\index.html"
$comparePath = "$PSScriptRoot\compare.html"
$cartPath = "$PSScriptRoot\cart.html"
$wishlistPath = "$PSScriptRoot\wishlist.html"
$singleProductPath = "$PSScriptRoot\single-product.html"

function Open-Page($path) {
    Write-Host "Opening: $path"
    try {
        Start-Process $path
        Write-Host "Successfully opened $path"
        return $true
    } catch {
        Write-Host "Error opening $path"
        return $false
    }
}

# Test main pages
Write-Host "\nTesting main pages...\n"
$success = $true

if (-not (Open-Page $indexPath)) { $success = $false }
Start-Sleep -Seconds 2

if (-not (Open-Page $comparePath)) { $success = $false }
Start-Sleep -Seconds 2

if (-not (Open-Page $cartPath)) { $success = $false }
Start-Sleep -Seconds 2

if (-not (Open-Page $wishlistPath)) { $success = $false }
Start-Sleep -Seconds 2

if (-not (Open-Page $singleProductPath)) { $success = $false }

if ($success) {
    Write-Host "\nAll pages opened successfully!\n"
} else {
    Write-Host "\nThere were errors opening some pages.\n"
}