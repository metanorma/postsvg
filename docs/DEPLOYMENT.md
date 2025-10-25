# Deploying Postsvg Documentation

This guide explains how to deploy the Postsvg documentation site to various platforms.

## Quick Deploy to GitHub Pages

The easiest deployment method is GitHub Pages (already configured).

### Prerequisites

- Repository pushed to GitHub
- Documentation in `docs/` directory
- `_config.yml` properly configured

### Steps

1. **Enable GitHub Pages:**
   ```
   Repository Settings → Pages
   Source: Deploy from a branch
   Branch: main
   Folder: /docs
   ```

2. **Wait for deployment:**
   - GitHub Actions will automatically build the site
   - Check the Actions tab for build status
   - Site will be available at: `https://metanorma.github.io/postsvg`

3. **Verify deployment:**
   ```sh
   # Check the site is live
   curl -I https://metanorma.github.io/postsvg
   ```

### Troubleshooting GitHub Pages

**Problem:** Site not building

**Solution:**
```sh
# Check _config.yml syntax
bundle exec jekyll build

# View build logs in GitHub Actions tab
```

**Problem:** 404 errors on pages

**Solution:**
- Ensure baseurl in `_config.yml` matches repository name
- Check file extensions are `.adoc` not `.md`
- Verify `jekyll-asciidoc` plugin is in `_config.yml`

## Local Testing

Always test locally before deploying:

```sh
cd docs

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# View at http://localhost:4000/postsvg

# Build static site
bundle exec jekyll build

# Output in _site/
```

### Local Testing Checklist

- [ ] All pages load without errors
- [ ] Navigation works correctly
- [ ] Search functions properly
- [ ] Links are not broken
- [ ] Code examples display correctly
- [ ] Images/diagrams load
- [ ] Mobile layout works

## Deploy to Netlify

For continuous deployment with Netlify:

### Setup

1. **Create `netlify.toml` in repository root:**

```toml
[build]
  base = "docs"
  publish = "_site"
  command = "bundle exec jekyll build"

[build.environment]
  RUBY_VERSION = "3.2"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

2. **Connect repository:**
   - Go to Netlify dashboard
   - "New site from Git"
   - Select GitHub repository
   - Configure build settings (auto-detected from netlify.toml)

3. **Deploy:**
   - Push to main branch
   - Netlify automatically builds and deploys
   - Site available at: `https://your-site.netlify.app`

### Custom Domain on Netlify

1. **Add domain:**
   ```
   Site Settings → Domain Management → Add custom domain
   ```

2. **Configure DNS:**
   ```
   Add CNAME record:
   docs.postsvg.org → your-site.netlify.app
   ```

3. **Enable HTTPS:**
   - Automatically enabled by Netlify
   - Free Let's Encrypt certificate

## Deploy to Vercel

For deployment with Vercel:

### Setup

1. **Install Vercel CLI:**
   ```sh
   npm install -g vercel
   ```

2. **Create `vercel.json` in docs directory:**

```json
{
  "buildCommand": "bundle exec jekyll build",
  "outputDirectory": "_site",
  "framework": "jekyll"
}
```

3. **Deploy:**
   ```sh
   cd docs
   vercel
   ```

4. **Production deployment:**
   ```sh
   vercel --prod
   ```

## Deploy to Custom Server

For deployment to your own server:

### Build Static Site

```sh
cd docs
bundle install
bundle exec jekyll build

# Output is in _site/
```

### Upload to Server

```sh
# Using rsync
rsync -avz _site/ user@server:/var/www/docs/

# Using scp
scp -r _site/* user@server:/var/www/docs/
```

### Nginx Configuration

```nginx
server {
    listen 80;
    server_name docs.postsvg.org;

    root /var/www/docs;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Enable gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

### Apache Configuration

```apache
<VirtualHost *:80>
    ServerName docs.postsvg.org
    DocumentRoot /var/www/docs

    <Directory /var/www/docs>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Enable compression
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
    </IfModule>
</VirtualHost>
```

## Automated Deployment with GitHub Actions

Create `.github/workflows/deploy-docs.yml`:

```yaml
name: Deploy Documentation

on:
  push:
    branches: [ main ]
    paths:
      - 'docs/**'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
          bundler-cache: true
          working-directory: docs

      - name: Build site
        run: |
          cd docs
          bundle exec jekyll build

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs/_site
```

## Custom Domain Setup

### GitHub Pages Custom Domain

1. **Add CNAME file:**
   ```sh
   echo "docs.postsvg.org" > docs/CNAME
   ```

2. **Configure DNS:**
   ```
   CNAME record:
   docs.postsvg.org → metanorma.github.io

   Or A records:
   docs.postsvg.org → 185.199.108.153
   docs.postsvg.org → 185.199.109.153
   docs.postsvg.org → 185.199.110.153
   docs.postsvg.org → 185.199.111.153
   ```

3. **Enable HTTPS:**
   ```
   Repository Settings → Pages → Enforce HTTPS
   ```

## Monitoring Deployment

### Check Build Status

**GitHub Pages:**
```sh
# Check Actions tab in repository
# Or use GitHub API:
curl https://api.github.com/repos/metanorma/postsvg/pages/builds/latest
```

**Netlify:**
```sh
# Check Netlify dashboard
# Or use Netlify CLI:
netlify status
```

### Monitor Site Health

```sh
# Check site is accessible
curl -I https://docs.postsvg.org

# Check specific pages
curl -s https://docs.postsvg.org/getting-started/ | grep "<title>"

# Check for broken links (using linkchecker)
linkchecker https://docs.postsvg.org
```

## Rollback Deployment

### GitHub Pages

```sh
# Revert last commit
git revert HEAD
git push origin main

# Or deploy specific commit
git checkout <commit-hash> docs/
git commit -m "Rollback docs to <commit-hash>"
git push origin main
```

### Netlify

```
Deploys → Select previous deployment → Publish deploy
```

## Performance Optimization

### Enable Caching

Add to `_config.yml`:

```yaml
# Minify HTML
compress_html:
  clippings: all
  comments: all
  endings: all
  ignore:
    envs: [development]
```

### Optimize Images

```sh
# Install image optimizer
gem install image_optim image_optim_pack

# Optimize images
image_optim -r docs/images/
```

### Enable CDN

**Using Cloudflare:**
1. Add site to Cloudflare
2. Point DNS to Cloudflare nameservers
3. Enable caching and minification
4. Configure SSL/TLS to Full

## Post-Deployment Checklist

- [ ] Site loads at production URL
- [ ] All pages are accessible
- [ ] Navigation works correctly
- [ ] Search is functional
- [ ] HTTPS is enabled
- [ ] Custom domain resolves correctly
- [ ] Mobile layout renders properly
- [ ] No broken links
- [ ] Analytics tracking (if configured)
- [ ] Sitemap generated
- [ ] robots.txt is correct

## Troubleshooting

### Build Failures

**Missing dependencies:**
```sh
cd docs
bundle install
bundle exec jekyll build
```

**Plugin errors:**
```sh
# Check plugin versions in Gemfile
# Update plugins:
bundle update
```

### Deployment Issues

**Site not updating:**
```sh
# Clear GitHub Pages cache
# Push new commit:
git commit --allow-empty -m "Trigger rebuild"
git push origin main
```

**404 errors:**
```sh
# Check baseurl in _config.yml
# Verify file paths are correct
# Ensure jekyll-asciidoc is installed
```

## Support

For deployment issues:
- Check [GitHub Pages documentation](https://docs.github.com/en/pages)
- Review [Jekyll documentation](https://jekyllrb.com/docs/)
- See [just-the-docs theme docs](https://just-the-docs.com/)
- Create issue at https://github.com/metanorma/postsvg/issues

## Quick Reference

```sh
# Local development
cd docs && bundle exec jekyll serve

# Build static site
cd docs && bundle exec jekyll build

# Deploy to GitHub Pages
git push origin main

# Check build status
# Visit: https://github.com/metanorma/postsvg/actions

# Access deployed site
# Visit: https://metanorma.github.io/postsvg