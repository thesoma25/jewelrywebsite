# PowerShell script to test the complete e-commerce workflow

Write-Host "Opening all HTML pages for testing the complete e-commerce workflow..."
Write-Host "Please follow these steps to test the workflow:"
Write-Host "1. On the product page, select variations and add a product to cart"
Write-Host "2. On the cart page, adjust quantities and proceed to checkout"
Write-Host "3. On the checkout page, fill in the form and complete the purchase"
Write-Host "4. Observe the thank you message and click 'Continue Shopping'"
Write-Host ""

# Function to open HTML file in default browser
function Open-HtmlFile {
    param (
        [string]$FilePath
    )
    
    try {
        # Try using Invoke-Item (works in most cases)
        Invoke-Item -Path $FilePath
        return $true
    } catch {
        try {
            # Fallback to Start-Process
            Start-Process $FilePath
            return $true
        } catch {
            Write-Host "Error opening $FilePath - $($_.Exception.Message)"
            return $false
        }
    }
}

# Get the current directory
$currentDir = Get-Location

# Define the HTML files to open
$productPage = Join-Path -Path $currentDir -ChildPath "single-product.html"
$cartPage = Join-Path -Path $currentDir -ChildPath "cart.html"
$checkoutPage = Join-Path -Path $currentDir -ChildPath "checkout.html"

# Open the product page first
Write-Host "Opening product page..."
$result = Open-HtmlFile -FilePath $productPage

if ($result) {
    Write-Host "Product page opened successfully."
    Write-Host "After adding products to cart, press any key to open the cart page..."
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    # Open the cart page
    Write-Host "Opening cart page..."
    $result = Open-HtmlFile -FilePath $cartPage
    
    if ($result) {
        Write-Host "Cart page opened successfully."
        Write-Host "After reviewing the cart, press any key to open the checkout page..."
        $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        # Open the checkout page
        Write-Host "Opening checkout page..."
        $result = Open-HtmlFile -FilePath $checkoutPage
        
        if ($result) {
            Write-Host "Checkout page opened successfully."
            Write-Host "Complete the checkout process to test the full workflow."
        } else {
            Write-Host "Failed to open checkout page."
        }
    } else {
        Write-Host "Failed to open cart page."
    }
} else {
    Write-Host "Failed to open product page."
}

Write-Host ""
Write-Host "Testing workflow complete. Press any key to exit..."
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")