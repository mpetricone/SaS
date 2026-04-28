#!/usr/bin/env bash
set -e

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  SaS dev container — post-create setup               ║"
echo "╚══════════════════════════════════════════════════════╝"

echo ""
echo "==> Installing Ruby gems..."
bundle install

echo ""
echo "==> Installing JS packages..."
yarn install

echo ""
echo "==> Creating & migrating development database..."
bin/rails db:create db:migrate

echo ""
echo "==> Creating & migrating test database..."
RAILS_ENV=test bin/rails db:create db:migrate

echo ""
echo "==> Seeding development database (if seeds exist)..."
bin/rails db:seed || echo "  (seed skipped or errored — run manually if needed)"

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  Ready!                                               ║"
echo "║                                                       ║"
echo "║  Start server : bin/serve  (or rails s)               ║"
echo "║  Run tests    : rails test                            ║"
echo "║  System tests : rails test:system                     ║"
echo "║  Live browser : http://localhost:7900  (noVNC)        ║"
echo "╚══════════════════════════════════════════════════════╝"
