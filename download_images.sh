#!/bin/bash

# Script to download all images from StyleCare Shopify theme
# Created: November 4, 2025

STORE_URL="stylecare-is373.myshopify.com"
OUTPUT_DIR="shopify_images"

echo "=========================================="
echo "StyleCare Image Download Script"
echo "=========================================="
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Find all image references in JSON files
echo "Searching for images in theme files..."
echo ""

# Array to store unique image URLs
declare -A images

# Search for shopify:// references
while IFS= read -r line; do
    # Extract image filename from shopify://shop_images/filename pattern
    if [[ $line =~ shopify://shop_images/([^\"]+) ]]; then
        filename="${BASH_REMATCH[1]}"
        images["$filename"]=1
        echo "Found: $filename"
    fi
done < <(grep -r "shopify://shop_images/" templates/ config/ 2>/dev/null)

# Search for direct CDN URLs
while IFS= read -r line; do
    # Extract from cdn.shopify.com URLs
    if [[ $line =~ cdn\.shopify\.com/[^\"]*\/([^\"\/]+\.(jpg|jpeg|png|gif|webp)) ]]; then
        filename="${BASH_REMATCH[1]}"
        images["$filename"]=1
        echo "Found: $filename"
    fi
done < <(grep -r "cdn.shopify.com" templates/ config/ 2>/dev/null)

echo ""
echo "=========================================="
echo "Downloading images..."
echo "=========================================="
echo ""

# Download each unique image
count=0
for image in "${!images[@]}"; do
    # Try multiple CDN paths
    urls=(
        "https://$STORE_URL/cdn/shop/files/$image"
        "https://$STORE_URL/cdn/shop/images/$image"
        "https://cdn.shopify.com/s/files/1/0/0/$image"
    )
    
    downloaded=false
    for url in "${urls[@]}"; do
        echo -n "Trying: $url ... "
        if curl -f -s -L "$url" -o "$OUTPUT_DIR/$image" 2>/dev/null; then
            file_size=$(stat -f%z "$OUTPUT_DIR/$image" 2>/dev/null || stat -c%s "$OUTPUT_DIR/$image" 2>/dev/null)
            if [ "$file_size" -gt 1000 ]; then
                echo "✓ Downloaded ($file_size bytes)"
                ((count++))
                downloaded=true
                break
            else
                rm "$OUTPUT_DIR/$image"
                echo "✗ File too small"
            fi
        else
            echo "✗ Failed"
        fi
    done
    
    if [ "$downloaded" = false ]; then
        echo "  ⚠ Could not download: $image"
    fi
    echo ""
done

echo ""
echo "=========================================="
echo "Download Summary"
echo "=========================================="
echo "Total images found: ${#images[@]}"
echo "Successfully downloaded: $count"
echo "Saved to: $OUTPUT_DIR/"
echo ""

# List downloaded files
echo "Downloaded files:"
ls -lh "$OUTPUT_DIR/" | grep -v "^total" | awk '{print $9, "(" $5 ")"}'

echo ""
echo "Done!"
