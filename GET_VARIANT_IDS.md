# How to Get Variant IDs for Your Premium Videos

The issue is that you need **VARIANT IDs**, not Product IDs. Here's how to get them:

## Method 1: From Product Admin Page (EASIEST)

1. Go to your Shopify Admin: `https://stylecare-is373.myshopify.com/admin/products`

2. Click on each of your 6 premium video products

3. Look at the URL - it will be like: 
   ```
   https://stylecare-is373.myshopify.com/admin/products/9999999999
   ```
   That number (9999999999) is the **PRODUCT ID**

4. On the product page, scroll down to the "Variants" section

5. If there's only one variant (Default Title), click on it

6. The URL will change to something like:
   ```
   https://stylecare-is373.myshopify.com/admin/products/9999999999/variants/888888888888
   ```
   That second number (888888888888) is the **VARIANT ID** you need!

7. Copy that VARIANT ID for each of your 6 products

## Method 2: Using Browser Console

If you want to get ALL variant IDs at once:

1. Go to: `https://stylecare-is373.myshopify.com/admin/products.json`

2. You'll see JSON data for all your products

3. Find your 6 premium video products in the list

4. For each product, look for `"variants": [...]`

5. Copy the `"id"` from the first variant

Example JSON structure:
```json
{
  "products": [
    {
      "id": 9999999999,
      "title": "Professional Sewing Masterclass",
      "variants": [
        {
          "id": 888888888888,  <-- THIS IS WHAT YOU NEED!
          "title": "Default Title",
          "price": "49.99"
        }
      ]
    }
  ]
}
```

## What You Need to Give Me

Once you have the variant IDs, give me this information:

1. **Professional Sewing Masterclass ($49.99)** - Variant ID: ?
2. **Color Analysis & Psychology ($79.99)** - Variant ID: ?
3. **Start Your Styling Business ($99.99)** - Variant ID: ?
4. **Advanced Pattern Making ($129.99)** - Variant ID: ?
5. **Luxury Brand Styling ($69.99)** - Variant ID: ?
6. **Sustainable Fashion Practices ($59.99)** - Variant ID: ?

## After You Get the Variant IDs

I'll update the `templates/page.education.json` file with the correct variant IDs, and then your "Add to Cart" buttons will work with real Shopify checkout!
