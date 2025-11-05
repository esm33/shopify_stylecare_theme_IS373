# StyleCare Image Downloader for Windows
# Downloads all images from Shopify theme
# Created: November 4, 2025

$StoreUrl = "stylecare-is373.myshopify.com"
$OutputDir = "shopify_images"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "StyleCare Image Download Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Create output directory
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

Write-Host "Searching for images in theme files..." -ForegroundColor Yellow
Write-Host ""

# Find all image references
$imageFiles = @{}

# Search for shopify:// references in templates and config
Get-ChildItem -Path . -Include *.json -Recurse -File | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    
    # Match shopify://shop_images/filename
    $matches = [regex]::Matches($content, 'shopify://shop_images/([^"]+)')
    foreach ($match in $matches) {
        $filename = $match.Groups[1].Value
        $imageFiles[$filename] = $true
        Write-Host "Found: $filename" -ForegroundColor Green
    }
    
    # Match direct CDN URLs
    $matches = [regex]::Matches($content, 'cdn\.shopify\.com/[^"]*/([^"/]+\.(jpg|jpeg|png|gif|webp))')
    foreach ($match in $matches) {
        $filename = $match.Groups[1].Value
        $imageFiles[$filename] = $true
        Write-Host "Found: $filename" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Downloading images..." -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$downloadCount = 0
$totalImages = $imageFiles.Count

foreach ($image in $imageFiles.Keys) {
    $downloaded = $false
    
    # Try multiple CDN paths
    $urls = @(
        "https://$StoreUrl/cdn/shop/files/$image",
        "https://$StoreUrl/cdn/shop/images/$image"
    )
    
    foreach ($url in $urls) {
        Write-Host "Trying: $url ... " -NoNewline
        
        try {
            $outputPath = Join-Path $OutputDir $image
            Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
            
            $fileInfo = Get-Item $outputPath
            if ($fileInfo.Length -gt 1000) {
                $sizeKB = [math]::Round($fileInfo.Length / 1KB, 2)
                Write-Host "Success! Downloaded" $sizeKB "KB" -ForegroundColor Green
                $downloadCount++
                $downloaded = $true
                break
            } else {
                Remove-Item $outputPath
                Write-Host "Failed - File too small" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Failed" -ForegroundColor Red
        }
    }
    
    if (-not $downloaded) {
        Write-Host "  WARNING: Could not download:" $image -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Download Summary" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Total images found: $totalImages"
Write-Host "Successfully downloaded: $downloadCount" -ForegroundColor Green
Write-Host "Saved to: $OutputDir/" -ForegroundColor Yellow
Write-Host ""

# List downloaded files
Write-Host "Downloaded files:" -ForegroundColor Cyan
Get-ChildItem -Path $OutputDir | ForEach-Object {
    $sizeKB = [math]::Round($_.Length / 1KB, 2)
    Write-Host "  " $_.Name "(" $sizeKB "KB )"
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
