# GitHub Pages Deployment Design

## Goal

Auto-deploy the ComponentBrowserApp (showcase/playground) to GitHub Pages on every push to `main`.

**URL:** `https://bassiuz.github.io/neo-fade-ui/`

## Approach

A single GitHub Actions workflow (`.github/workflows/deploy-pages.yml`) that builds the Flutter web app and deploys it using GitHub's artifact-based Pages deployment.

## Workflow Steps

1. **Trigger:** Push to `main`
2. **Checkout** the repo
3. **Setup Flutter** via `subosito/flutter-action` pinned to `3.38.9`
4. **Install dependencies** — `flutter pub get`
5. **Build** — `flutter build web --release --base-href=/neo-fade-ui/`
6. **Disable service worker** — `sed` to set `serviceWorkerSettings: null` in `flutter_bootstrap.js`
7. **Upload artifact** — `actions/upload-pages-artifact` targeting `build/web`
8. **Deploy** — `actions/deploy-pages`

## Permissions

- `pages: write` and `id-token: write` on the workflow
- Concurrency group to prevent parallel deployments

## Manual Setup Required

In GitHub repo Settings > Pages, set source to "GitHub Actions".

## Files Changed

- **New:** `.github/workflows/deploy-pages.yml`
