# Postsvg Documentation

This directory contains the complete documentation for the Postsvg gem, built using Jekyll and the just-the-docs theme with AsciiDoc support.

## Quick Start

### View Locally

```sh
# Install dependencies
gem install jekyll jekyll-asciidoc just-the-docs

# Serve documentation site
cd docs
jekyll serve

# Open in browser
open http://localhost:4000/postsvg
```

### Build Static Site

```sh
cd docs
jekyll build

# Output in _site/ directory
```

## Documentation Structure

### Core Files

- **`_config.yml`** - Jekyll configuration with theme and plugin settings
- **`index.adoc`** - Main documentation homepage and navigation hub
- **`DOCUMENTATION_PLAN.md`** - Complete documentation roadmap and status

### Documentation Topics

All documentation follows a hierarchical structure:

```
docs/
├── index.adoc                    # Main entry point
├── getting-started.adoc          # Getting Started overview
├── getting-started/              # Getting Started child topics
│   ├── installation.adoc
│   ├── basic-usage.adoc
│   └── first-conversion.adoc
├── concepts.adoc                 # Core Concepts overview
├── api-reference.adoc            # API Reference overview
├── cli-reference.adoc            # CLI Reference overview
├── architecture.adoc             # Architecture overview
├── advanced-topics.adoc          # Advanced Topics overview
├── development.adoc              # Development Guide overview
├── contributing.adoc             # Contributing Guide
├── troubleshooting.adoc          # Troubleshooting Guide
├── faq.adoc                      # Frequently Asked Questions
├── postscript/                   # PostScript language docs
├── validation.adoc               # Validation system docs
└── optimization.adoc             # SVG optimization docs
```

## Documentation Standards

### Document Template

Every documentation file follows this structure:

```adoc
= Document Title
:page-nav_order: N
:page-parent: Parent Topic (if applicable)

== Purpose

Brief description of what this document covers.

== References

* link:../index.adoc[Documentation Home]
* link:related-topic.adoc[Related Topic]

== Concepts

**Key Term**:: Definition

== {Content Sections}

Main content with examples and explanations.

== Next Steps

* Link to follow-up topics

== Bibliography

* References and resources
```

### Key Principles

1. **MECE** - Mutually Exclusive, Collectively Exhaustive
2. **Examples** - Every feature has practical code examples
3. **Cross-References** - Links between related topics
4. **Standard Sections** - Purpose, References, Concepts, Bibliography
5. **Clarity** - Clear, concise, example-driven content

## Building for Production

### GitHub Pages Deployment

The site is configured for deployment to GitHub Pages:

```yaml
# In _config.yml
url: https://metanorma.github.io
baseurl: /postsvg
```

To deploy:

1. Push changes to `main` branch
2. Enable GitHub Pages in repository settings
3. Select source: `main` branch, `/docs` folder
4. Site will be available at configured URL

### Custom Domain

To use a custom domain:

1. Add `CNAME` file to docs directory:
   ```
   docs.postsvg.org
   ```

2. Update `_config.yml`:
   ```yaml
   url: https://docs.postsvg.org
   baseurl: ""
   ```

3. Configure DNS records for your domain

## Contributing to Documentation

### Adding New Topics

1. **Create file** in appropriate directory
2. **Follow template** structure (see above)
3. **Add to parent** topic's navigation
4. **Test locally** before committing
5. **Update** `DOCUMENTATION_PLAN.md`

### Writing Guidelines

**Do:**
- ✅ Use clear, concise language
- ✅ Provide code examples
- ✅ Include "Where" legends for parameters
- ✅ Cross-reference related topics
- ✅ Test all code examples

**Don't:**
- ❌ Use jargon without explanation
- ❌ Create orphan pages (no links to/from)
- ❌ Leave TODO comments in published docs
- ❌ Include untested code examples

### Code Examples

Use proper syntax highlighting:

````adoc
[source,ruby]
----
require 'postsvg'
svg = Postsvg.convert(ps_content)
----
````

````adoc
[source,sh]
----
postsvg convert input.ps output.svg
----
````

### Cross-References

Link to code with line numbers:

```adoc
[`Postsvg.convert(ps_content)`](../lib/postsvg.rb:13)
```

Link to other docs:

```adoc
link:../api-reference.adoc[API Reference]
link:installation.adoc[Installation Guide]
```

## Theme Customization

### Colors

Edit `_config.yml` to change theme colors:

```yaml
color_scheme: light  # or dark, or custom
```

### Search

Search is enabled by default:

```yaml
search_enabled: true
search:
  heading_level: 3
  previews: 3
```

### Navigation

Control navigation behavior:

```yaml
nav_sort: case_insensitive
nav_fold: true
```

## Troubleshooting

### Jekyll Build Errors

**Problem:** `Liquid Exception: No converter found`

**Solution:** Ensure `jekyll-asciidoc` is installed:
```sh
gem install jekyll-asciidoc
```

**Problem:** `Dependency Error: Unknown tag 'include'`

**Solution:** Use correct AsciiDoc include syntax:
```adoc
\include::path/to/file.adoc[]
```

### Theme Issues

**Problem:** Theme not loading

**Solution:** Check `_config.yml` has:
```yaml
theme: just-the-docs
remote_theme: just-the-docs/just-the-docs
```

### AsciiDoc Not Rendering

**Problem:** `.adoc` files showing as plain text

**Solution:** Ensure `asciidoc` plugin is configured:
```yaml
asciidoc: {}
asciidoctor:
  attributes:
    - idprefix=_
    - source-highlighter=rouge
```

## Documentation Metrics

Current status:

- **Parent Topics**: 10/10 complete (100%)
- **Child Topics**: 3/44 created (7%)
- **Code Examples**: 50+ examples
- **Cross-References**: 200+ internal links
- **Total Pages**: 13+ pages

## Next Steps

Priority child topics to create:

1. **Getting Started** (1 remaining):
   - `common-workflows.adoc`

2. **API Reference** (9 topics):
   - `postsvg-module.adoc`
   - `converter.adoc`
   - `interpreter.adoc`
   - `execution-context.adoc`
   - `graphics-state.adoc`
   - `svg-generator.adoc`
   - `path-builder.adoc`
   - `matrix.adoc`
   - `colors.adoc`

3. **CLI Reference** (5 topics):
   - `convert-command.adoc`
   - `batch-command.adoc`
   - `check-command.adoc`
   - `version-command.adoc`
   - `cli-options.adoc`

See `DOCUMENTATION_PLAN.md` for complete roadmap.

## Resources

- [Just the Docs Theme](https://just-the-docs.com/)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [AsciiDoc Syntax](https://docs.asciidoctor.org/asciidoc/latest/)
- [GitHub Pages](https://docs.github.com/en/pages)

## License

This documentation is part of the Postsvg project and is licensed under the BSD 2-Clause License.

## Support

For documentation issues:
- [GitHub Issues](https://github.com/metanorma/postsvg/issues)
- [Contributing Guide](contributing.adoc)