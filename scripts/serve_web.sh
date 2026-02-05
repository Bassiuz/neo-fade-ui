#!/bin/bash
# Serve Flutter web app on local network (accessible via Tailscale)

set -e

PORT=${1:-8080}

echo "Building Flutter web in release mode..."
fvm flutter build web --release

echo "Disabling service worker to prevent caching issues..."
cd build/web
cp flutter_bootstrap.js flutter_bootstrap.js.bak
sed -i '' 's/serviceWorkerSettings: {[^}]*}/serviceWorkerSettings: null/' flutter_bootstrap.js

echo ""
echo "Starting server on port $PORT..."
echo "Access the app at:"
echo "  - Local: http://localhost:$PORT"
echo "  - Tailscale IPv4: http://<tailscale-ip>:$PORT"
echo "  - Tailscale IPv6: http://[<tailscale-ipv6>]:$PORT"
echo ""
echo "Press Ctrl+C to stop"
echo ""

python3 -m http.server $PORT --bind ::
