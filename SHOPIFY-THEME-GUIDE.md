# Shopify Theme Development Guide

## Quick Start with Shopify CLI

### Prerequisites
- ✅ Shopify Partner account
- ✅ Shopify CLI installed
- A development store (or production store)

### Initial Setup

#### 1. Create a New Theme
```bash
shopify theme init my-theme-name
```
This creates a new theme from a template (Dawn by default).

#### 2. Connect to Your Store
```bash
cd my-theme-name
shopify theme dev --store your-store.myshopify.com
```
- You'll be prompted to log in
- Opens a local preview (typically `http://127.0.0.1:9292`)
- Hot reload enabled - changes appear instantly

### Theme Development Workflow

#### Directory Structure
```
my-theme/
├── assets/          # CSS, JS, images
├── config/          # Theme settings (settings_schema.json)
├── layout/          # Base templates (theme.liquid)
├── locales/         # Translation files
├── sections/        # Reusable sections
├── snippets/        # Reusable code blocks
└── templates/       # Page templates (product, collection, etc.)
```

#### Key Commands

**Development Mode** (Live preview with hot reload)
```bash
shopify theme dev
```

**Push to Store** (Upload theme)
```bash
shopify theme push
```

**Pull from Store** (Download theme)
```bash
shopify theme pull
```

**Publish Theme**
```bash
shopify theme publish
```

**Check Theme**
```bash
shopify theme check
```

### Development Best Practices

#### 1. Start with a Base Theme
- Use Dawn (Shopify's reference theme) as starting point
- Or clone an existing theme:
```bash
shopify theme pull --development
```

#### 2. Work in Development Mode
- Always use `shopify theme dev` for development
- Changes sync automatically
- Test on actual store data

#### 3. Use Sections & Blocks
- Build modular sections for flexibility
- Enable customization in theme editor
- Example section structure:
```liquid
{% schema %}
{
  "name": "My Section",
  "settings": [
    {
      "type": "text",
      "id": "heading",
      "label": "Heading"
    }
  ]
}
{% endschema %}
```

#### 4. Version Control
```bash
git init
git add .
git commit -m "Initial theme setup"
```

### Common Workflows

#### Starting a Theme from Dawn
```bash
shopify theme init my-custom-theme
cd my-custom-theme
shopify theme dev --store your-store.myshopify.com
```

#### Modifying Existing Store Theme
```bash
shopify theme pull --development
shopify theme dev
# Make changes...
shopify theme push
```

#### Deploy to Production
```bash
# Test first
shopify theme push --development

# When ready
shopify theme push --live
# Or publish from admin
shopify theme publish
```

### Theme Customization Tips

#### 1. Custom CSS
Add to `assets/theme.css` or create new file:
```liquid
{{ 'custom-styles.css' | asset_url | stylesheet_tag }}
```

#### 2. Custom JavaScript
Add to `assets/theme.js` or create new file:
```liquid
{{ 'custom-script.js' | asset_url | script_tag }}
```

#### 3. Create Custom Sections
File: `sections/custom-hero.liquid`
```liquid
<div class="hero">
  <h1>{{ section.settings.heading }}</h1>
</div>

{% schema %}
{
  "name": "Custom Hero",
  "settings": [
    {
      "type": "text",
      "id": "heading",
      "label": "Heading",
      "default": "Welcome"
    }
  ],
  "presets": [
    {
      "name": "Custom Hero"
    }
  ]
}
{% endschema %}
```

#### 4. Modify Existing Templates
- Pull theme first
- Edit templates in `templates/` directory
- Use JSON templates for section-based pages
- Use Liquid templates for more control

### Testing & Quality

#### Run Theme Check
```bash
shopify theme check
```
Validates:
- Liquid syntax
- Performance issues
- Accessibility
- Best practices

#### Preview on Different Devices
- Use `shopify theme dev` preview URL
- Test responsive design
- Check mobile experience

### Going Live

#### Checklist
1. ✅ Test all pages
2. ✅ Run `shopify theme check`
3. ✅ Test checkout process
4. ✅ Verify SEO settings
5. ✅ Check mobile responsiveness
6. ✅ Test theme customizer

#### Deploy
```bash
# Option 1: Push to live theme
shopify theme push --live

# Option 2: Push as unpublished, then publish
shopify theme push
shopify theme publish --theme-id=YOUR_THEME_ID
```

### Helpful Resources

- **Shopify Liquid Docs**: shopify.dev/docs/themes/liquid
- **Dawn Theme GitHub**: github.com/Shopify/dawn
- **Theme Architecture**: shopify.dev/docs/themes/architecture
- **CLI Reference**: shopify.dev/docs/themes/tools/cli

### Troubleshooting

#### Authentication Issues
```bash
shopify logout
shopify auth login
```

#### Can't Connect to Store
- Verify store URL: `your-store.myshopify.com`
- Check you have staff/partner access
- Ensure store is not password-protected for development

#### Changes Not Appearing
- Check `shopify theme dev` is running
- Clear browser cache
- Verify you're viewing the dev preview URL

### Quick Command Reference

```bash
# Initialize new theme
shopify theme init <name>

# Development with hot reload
shopify theme dev [--store <store>]

# Upload theme
shopify theme push [--development|--live]

# Download theme
shopify theme pull [--development|--live]

# Publish theme
shopify theme publish

# List themes
shopify theme list

# Delete theme
shopify theme delete

# Check theme quality
shopify theme check
```

---

## Next Steps

1. **Start with `shopify theme init`** - Get a base theme
2. **Run `shopify theme dev`** - Start development mode
3. **Customize** - Edit files and see changes instantly
4. **Test** - Use `shopify theme check`
5. **Deploy** - Push when ready with `shopify theme push`

Good luck with your Shopify theme development! 🚀
