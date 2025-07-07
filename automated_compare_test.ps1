# Automated test script for compare functionality

# Function to open a browser with a specific URL
function Open-Browser {
    param (
        [string]$url
    )
    
    Write-Host "Opening browser with URL: $url"
    Start-Process $url
}

# Test the compare functionality
Write-Host "\n===== AUTOMATED COMPARE FUNCTIONALITY TEST =====\n"

# Step 1: Open single product page
$singleProductPath = "file:///$PSScriptRoot/single-product.html"
Write-Host "Step 1: Opening single product page"
Open-Browser $singleProductPath

# Wait for user to interact with the page
Write-Host "\nPlease perform the following actions on the single product page:"
Write-Host "1. Click the 'Add to Compare' button"
Write-Host "2. Verify that a notification appears confirming the product was added"
Write-Host "3. Check that the compare count in the header increases by 1"
$response = Read-Host "Did the 'Add to Compare' button work correctly? (y/n)"

if ($response -eq "y") {
    Write-Host "'Add to Compare' button test: PASSED" -ForegroundColor Green
} else {
    Write-Host "'Add to Compare' button test: FAILED" -ForegroundColor Red
}

# Step 2: Open compare page
$comparePath = "file:///$PSScriptRoot/compare.html"
Write-Host "\nStep 2: Opening compare page"
Open-Browser $comparePath

# Wait for user to interact with the page
Write-Host "\nPlease verify the following on the compare page:"
Write-Host "1. The product you added is displayed correctly in the comparison table"
Write-Host "2. The 'Remove' button works when clicked"
Write-Host "3. The 'Add to Cart' button works when clicked"
Write-Host "4. The 'Clear All' button works when clicked"
$response = Read-Host "Did all the compare page functions work correctly? (y/n)"

if ($response -eq "y") {
    Write-Host "Compare page functionality test: PASSED" -ForegroundColor Green
} else {
    Write-Host "Compare page functionality test: FAILED" -ForegroundColor Red
}

# Step 3: Test product limit
Write-Host "\nStep 3: Testing product limit (max 4 products)"
Write-Host "Please open the browser console (F12) and run the following command:"
Write-Host "localStorage.setItem('compareList', JSON.stringify([" -ForegroundColor Cyan
Write-Host "  {id: 'test1', name: 'Test Product 1', price: '$99.99', image: ''}," -ForegroundColor Cyan
Write-Host "  {id: 'test2', name: 'Test Product 2', price: '$89.99', image: ''}," -ForegroundColor Cyan
Write-Host "  {id: 'test3', name: 'Test Product 3', price: '$79.99', image: ''}," -ForegroundColor Cyan
Write-Host "  {id: 'test4', name: 'Test Product 4', price: '$69.99', image: ''}" -ForegroundColor Cyan
Write-Host "]))" -ForegroundColor Cyan

Write-Host "\nAfter running the command, refresh the page and try to add another product to compare."
Write-Host "You should see a notification indicating you can only compare up to 4 products."
$response = Read-Host "Did the product limit (max 4) work correctly? (y/n)"

if ($response -eq "y") {
    Write-Host "Product limit test: PASSED" -ForegroundColor Green
} else {
    Write-Host "Product limit test: FAILED" -ForegroundColor Red
}

# Step 4: Test localStorage functionality
Write-Host "\nStep 4: Testing localStorage functionality"
Write-Host "Please run the following commands in the browser console (F12):"
Write-Host "1. localStorage.getItem('compareList') // Should return the test products" -ForegroundColor Cyan
Write-Host "2. localStorage.setItem('compareList', JSON.stringify([])) // Clear test data" -ForegroundColor Cyan
Write-Host "3. localStorage.getItem('compareList') // Should return an empty array" -ForegroundColor Cyan

$response = Read-Host "Did the localStorage commands work correctly? (y/n)"

if ($response -eq "y") {
    Write-Host "localStorage functionality test: PASSED" -ForegroundColor Green
} else {
    Write-Host "localStorage functionality test: FAILED" -ForegroundColor Red
}

# Summary
Write-Host "\n===== TEST SUMMARY =====\n"
Write-Host "Please provide your overall assessment of the compare functionality:"
Write-Host "1. Does the 'Add to Compare' button work correctly?"
Write-Host "2. Does the compare page display products correctly?"
Write-Host "3. Do the 'Remove', 'Add to Cart', and 'Clear All' buttons work?"
Write-Host "4. Does the product limit (max 4) work correctly?"
Write-Host "5. Does localStorage store and retrieve comparison data correctly?"

$overallResponse = Read-Host "Overall, does the compare functionality work correctly? (y/n)"

if ($overallResponse -eq "y") {
    Write-Host "\nOVERALL TEST RESULT: PASSED" -ForegroundColor Green
    Write-Host "The compare functionality appears to be working correctly.\n"
} else {
    Write-Host "\nOVERALL TEST RESULT: FAILED" -ForegroundColor Red
    Write-Host "The compare functionality has issues that need to be addressed.\n"
    
    $issues = Read-Host "Please describe the issues you encountered"
    Write-Host "\nIssues reported: $issues\n"
}

Write-Host "Test completed. Thank you for testing the compare functionality!"