# GitHub Pages Deployment Instructions

This guide provides step-by-step instructions for deploying the PostSVG documentation to GitHub Pages.

## Prerequisites

- Repository must be public or have GitHub Pages enabled for private repositories
- Documentation is committed and pushed to the `main` branch
- All link validation checks have passed

## Enabling GitHub Pages

### Step 1: Navigate to Repository Settings

1. Go to the PostSVG repository: https://github.com/metanorma/postsvg
2. Click on the **Settings** tab (located in the top navigation bar)
3. In the left sidebar, scroll down to the **Code and automation** section
4. Click on **Pages**

### Step 2: Configure GitHub Pages Source

1. Under **Build and deployment**, find the **Source** section
2. Click the dropdown menu under **Source** and select **Deploy from a branch**
3. Under **Branch**, select:
   - Branch: `main`
   - Folder: `/docs`
4. Click **Save**

### Step 3: Wait for Deployment

GitHub Pages will automatically build and deploy your site. This typically takes 1-3 minutes.

## Expected Deployment URL

Once deployed, your documentation will be available at:

```
https://metanorma.github.io/postsvg/
```

The main documentation page will be:

```
https://metanorma.github.io/postsvg/index.html
```

## Verifying Deployment

### Method 1: Check GitHub Actions

1. Go to the **Actions** tab in your repository
2. Look for a workflow named **pages build and deployment**
3. Wait for the workflow to complete (green checkmark ✓)
4. The workflow details will show the deployment URL

### Method 2: Check Settings Page

1. Return to **Settings** > **Pages**
2. At the top of the page, you'll see a banner that says:
   ```
   Your site is live at https://metanorma.github.io/postsvg/
   ```
3. Click **Visit site** to view your documentation

### Method 3: Manual Verification

1. Open a browser and navigate to: https://metanorma.github.io/postsvg/
2. Verify that the documentation loads correctly
3. Check navigation between pages works
4. Verify all internal links are functional

## Monitoring GitHub Actions Workflows

### Link Check Workflow

The repository includes a `link-check.yml` workflow that runs on:
- Every push to `main`
- Every pull request
- Weekly schedule (Mondays at 00:00 UTC)

To monitor this workflow:

1. Go to **Actions** tab
2. Click on **Check Documentation Links** workflow
3. View recent runs and their status

### Troubleshooting Link Check Failures

If the link check workflow fails:

1. Click on the failed workflow run
2. Click on the **check-links** job
3. Review the output to identify broken links
4. Fix the broken links in the documentation
5. Commit and push the changes
6. The workflow will run automatically

## Common Issues and Solutions

### Issue 1: Site Not Updating

**Symptom**: Changes to documentation don't appear on the live site

**Solutions**:
- Clear your browser cache (Ctrl+Shift+R or Cmd+Shift+R)
- Wait 5-10 minutes for GitHub's CDN to update
- Check that changes were actually pushed to the `main` branch
- Verify the workflow completed successfully in Actions tab

### Issue 2: 404 Page Not Found

**Symptom**: GitHub Pages shows 404 error

**Solutions**:
- Ensure the `/docs` folder exists in the `main` branch
- Verify `index.html` exists in the `/docs` folder
- Check that GitHub Pages is configured to use `/docs` folder
- Ensure the repository is public (or Pages is enabled for private repos)

### Issue 3: Broken Links

**Symptom**: Internal links don't work or show 404 errors

**Solutions**:
- Run `rake check:links` locally to identify broken links
- Ensure all file references use relative paths
- Verify file extensions match exactly (case-sensitive)
- Check that cross-references use correct paths

### Issue 4: Workflow Failures

**Symptom**: GitHub Actions workflows fail

**Solutions**:
- Check the workflow logs in the Actions tab
- Ensure all required files are committed
- Verify that Ruby and dependencies are properly installed
- For link-check failures, review the specific broken links reported

### Issue 5: Custom Domain Not Working

**Symptom**: Custom domain doesn't resolve to GitHub Pages

**Solutions**:
- Verify DNS records are correctly configured
- Allow 24-48 hours for DNS propagation
- Check that the CNAME file exists in `/docs`
- Ensure HTTPS is enabled in GitHub Pages settings

## Maintenance

### Regular Tasks

1. **Weekly Link Checks**: Monitor the automated weekly link check workflow
2. **Update Documentation**: Keep documentation in sync with code changes
3. **Review Pull Requests**: Ensure documentation changes pass link validation
4. **Monitor Issues**: Address documentation-related issues promptly

### Best Practices

1. Always run `rake check:links` before pushing documentation changes
2. Use relative paths for all internal documentation links
3. Test documentation locally before deploying
4. Keep the documentation structure organized and MECE
5. Update the documentation when adding new features or commands

## Rollback Procedure

If you need to rollback to a previous version:

1. Identify the commit hash of the working version
2. Create a new branch from that commit:
   ```bash
   git checkout -b rollback-docs <commit-hash>
   ```
3. Force push to main (use with caution):
   ```bash
   git push origin rollback-docs:main --force
   ```
4. Wait for GitHub Pages to redeploy

## Support

For issues specific to GitHub Pages deployment:
- GitHub Pages Documentation: https://docs.github.com/en/pages
- GitHub Actions Documentation: https://docs.github.com/en/actions

For PostSVG documentation issues:
- Open an issue at: https://github.com/metanorma/postsvg/issues
- Include the page URL and description of the problem
- Attach screenshots if relevant

## Quick Reference Commands

```bash
# Check links locally
rake check:links

# Push documentation to GitHub
git push origin main

# View git log
git log --oneline

# Check current branch
git branch

# View workflow status (requires GitHub CLI)
gh workflow list
gh run list --workflow=link-check.yml
```

## Deployment Checklist

Before deploying documentation updates:

- [ ] All new files created and committed
- [ ] Link validation passes (`rake check:links`)
- [ ] Changes pushed to `main` branch
- [ ] GitHub Actions workflows triggered
- [ ] Link check workflow passes
- [ ] Documentation accessible at GitHub Pages URL
- [ ] All navigation links work correctly
- [ ] Cross-references resolve properly
- [ ] No 404 errors on any pages

---

Last Updated: 2025-10-25