# Project Guidelines for Claude

## Flutter Development Rules

- **Small widgets**: Keep widgets as small as possible, breaking them into smaller components when needed
- **Testing**: Write widget and golden tests for every new widget
- **Reuse widgets**: Do not write new widgets when existing widgets can be reused for the same purpose
- **No private classes**: Do not use private classes (prefixed with `_`), put them in their own file instead
- **One class per file**: Only use 1 class per file. For additional classes, create new files
- **Test before refactoring**: When refactoring, ensure a test exists for that part before making changes. Write a test first if one doesn't exist, then ask me to verify the test before continuing with the refactor
- **Use App Theme**: Always use styles, colors, fonts, and sizing from the App Theme. Avoid fixed colors, custom fonts, or magic numbers in widgets
- **Clean up unused code**: Remove code that is no longer used, delete files and classes that are not needed
- **Use FVM**: Use Flutter Version Management (FVM) to manage Flutter SDK versions for the project. Use FVM to run Flutter Commands. Use FVM to run Dart commands
- **Do not edit Generated Files**: Use the build_runner (Through FVM) to generate files. Do not manually edit generated files
- **UI Folder Structure**: All reusable UI elements (buttons, cards, sheets, dialogs, indicators, navigation) must be placed in the `/lib/ui/` folder. Page-specific widgets that are not reusable remain in their respective page folders. Every UI element must have a golden test showing all its states/variants
- **Tests are the truth**: Whenever I ask you to build something that conflicts with how tests are written at the moment, you should ask me if the tests should be updated or if the implementation approach should change so the functionality keeps working like it is tested.

## Serving Flutter Web (Tailscale/Network Access)

Flutter web debug mode has issues with service worker caching. To serve the web app reliably on the local network (e.g., via Tailscale):

```bash
./scripts/serve_web.sh
```

This script:
1. Builds in release mode (`fvm flutter build web --release`)
2. Disables service worker to prevent caching issues
3. Serves on `0.0.0.0:8080` (accessible from any network interface)

Access the app at `http://<tailscale-ip>:8080`

**Manual steps if needed:**
```bash
fvm flutter build web --release
cd build/web
sed -i '' 's/serviceWorkerSettings: {[^}]*}/serviceWorkerSettings: null/' flutter_bootstrap.js
python3 -m http.server 8080 --bind 0.0.0.0
```
