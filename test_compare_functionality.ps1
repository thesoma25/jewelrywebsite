# Test script to verify the compare functionality

# Function to check if localStorage is working properly
function Test-LocalStorage {
    Write-Host "\nTesting localStorage functionality...\n"
    
    # Open the single product page
    $singleProductPath = "$PSScriptRoot\single-product.html"
    Write-Host "Opening: $singleProductPath"
    Start-Process $singleProductPath
    
    Write-Host "\nManual Testing Instructions:\n"
    Write-Host "1. On the single product page, open browser developer tools (F12)"
    Write-Host "2. Go to the Console tab"
    Write-Host "3. Run the following commands to test localStorage functionality:"
    Write-Host "   - localStorage.getItem('compareList') // Should return null or an array"
    Write-Host "   - localStorage.setItem('compareList', JSON.stringify([{id: 'test', name: 'Test Product', price: '$99.99', image: ''}]))"
    Write-Host "   - localStorage.getItem('compareList') // Should return the test product"
    Write-Host "   - localStorage.setItem('compareList', JSON.stringify([])) // Clear test data"
    Write-Host "4. If all commands work without errors, localStorage is functioning correctly"
}

# Function to test the compare button functionality
function Test-CompareButton {
    Write-Host "\nTesting 'Add to Compare' button functionality...\n"
    
    # Open the single product page
    $singleProductPath = "$PSScriptRoot\single-product.html"
    Write-Host "Opening: $singleProductPath"
    Start-Process $singleProductPath
    
    Write-Host "\nManual Testing Instructions:\n"
    Write-Host "1. On the single product page, click the 'Add to Compare' button"
    Write-Host "2. Verify that a notification appears confirming the product was added"
    Write-Host "3. Check that the compare count in the header increases by 1"
    Write-Host "4. Click the 'Add to Compare' button again"
    Write-Host "5. Verify that a notification appears indicating the product is already in the comparison list"
}

# Function to test the compare page functionality
function Test-ComparePage {
    Write-Host "\nTesting compare page functionality...\n"
    
    # Open the compare page
    $comparePath = "$PSScriptRoot\compare.html"
    Write-Host "Opening: $comparePath"
    Start-Process $comparePath
    
    Write-Host "\nManual Testing Instructions:\n"
    Write-Host "1. On the compare page, verify that products added to comparison are displayed correctly"
    Write-Host "2. Test the 'Remove' button for a product and verify it's removed from the table"
    Write-Host "3. Test the 'Add to Cart' button and verify the product is added to the cart"
    Write-Host "4. Test the 'Clear All' button and verify all products are removed from comparison"
    Write-Host "5. Verify the empty comparison message is displayed after clearing all products"
}

# Function to test the limit of 4 products
function Test-ProductLimit {
    Write-Host "\nTesting product limit functionality...\n"
    
    # Open the single product page
    $singleProductPath = "$PSScriptRoot\single-product.html"
    Write-Host "Opening: $singleProductPath"
    Start-Process $singleProductPath
    
    Write-Host "\nManual Testing Instructions:\n"
    Write-Host "1. First, clear your comparison list by going to the compare page and clicking 'Clear All'"
    Write-Host "2. Open the browser console (F12) and run the following command to add 4 test products:"
    Write-Host "   localStorage.setItem('compareList', JSON.stringify([\n"
    Write-Host "     {id: 'test1', name: 'Test Product 1', price: '$99.99', image: ''},\n"
    Write-Host "     {id: 'test2', name: 'Test Product 2', price: '$89.99', image: ''},\n"
    Write-Host "     {id: 'test3', name: 'Test Product 3', price: '$79.99', image: ''},\n"
    Write-Host "     {id: 'test4', name: 'Test Product 4', price: '$69.99', image: ''}\n"
    Write-Host "   ]));"
    Write-Host "3. Refresh the page and verify the compare count shows 4"
    Write-Host "4. Click the 'Add to Compare' button for another product"
    Write-Host "5. Verify that a notification appears indicating you can only compare up to 4 products"
}

# Main test menu
function Show-TestMenu {
    Clear-Host
    Write-Host "===== Compare Functionality Test Menu ====="
    Write-Host "1. Test localStorage functionality"
    Write-Host "2. Test 'Add to Compare' button"
    Write-Host "3. Test compare page functionality"
    Write-Host "4. Test product limit (max 4 products)"
    Write-Host "5. Run all tests"
    Write-Host "6. Exit"
    Write-Host "=========================================="
    
    $choice = Read-Host "Enter your choice (1-6)"
    
    switch ($choice) {
        "1" { Test-LocalStorage; Pause; Show-TestMenu }
        "2" { Test-CompareButton; Pause; Show-TestMenu }
        "3" { Test-ComparePage; Pause; Show-TestMenu }
        "4" { Test-ProductLimit; Pause; Show-TestMenu }
        "5" { 
            Test-LocalStorage
            Pause
            Test-CompareButton
            Pause
            Test-ComparePage
            Pause
            Test-ProductLimit
            Pause
            Show-TestMenu
        }
        "6" { return }
        default { Write-Host "Invalid choice. Please try again."; Pause; Show-TestMenu }
    }
}

# Start the test menu
Show-TestMenu