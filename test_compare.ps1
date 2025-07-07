# Test script to check the compare functionality

# Open the single product page
$singleProductPath = "$PSScriptRoot\single-product.html"
Write-Host "Opening single product page: $singleProductPath"
Start-Process $singleProductPath

Write-Host "\nInstructions for testing compare functionality:\n"
Write-Host "1. On the single product page, click 'Add to Compare' button"
Write-Host "2. Open another product and add it to compare as well"
Write-Host "3. Click on the compare icon in the header to go to compare page"
Write-Host "4. Verify that products are displayed correctly in the comparison table"
Write-Host "5. Test 'Remove' and 'Add to Cart' buttons on the compare page"
Write-Host "6. Test 'Clear All' button on the compare page"
Write-Host "\nPlease follow these steps manually to verify the compare functionality works correctly.\n"