# Metadata & README Design

## Goal

Replace default Flutter boilerplate in web metadata, icons, and README with proper project branding and a component showcase.

## Changes

### Web Metadata
- **manifest.json & index.html**: Name → "Neo Fade UI", description from pubspec, dark theme colors
- **Icons**: Generate "NF" text-on-gradient PNGs for favicon and PWA icons (192, 512, maskable)

### README
- Title + description
- Live demo link to GitHub Pages
- Component showcase using golden test images from `test/goldens/`, grouped by category
- Getting started section with FVM instructions
