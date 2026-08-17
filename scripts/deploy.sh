#!/usr/bin/env bash
#
# Server-side deployment tasks for eastcarib.vatcar.net.
# Invoked by .github/workflows/deploy.yml after the working tree has been
# reset to origin/main. Safe to run manually over SSH as well:
#
#   bash ~/repositories/eastcarib-zone/scripts/deploy.sh

set -euo pipefail
cd "$(dirname "$0")/.."

# cPanel routes the account's CLI php through the MultiPHP selection at
# /usr/local/bin/php. If that resolves to the wrong version on this server,
# override with the explicit binary, e.g.:
#   PHP_BIN=/opt/cpanel/ea-php83/root/usr/bin/php bash scripts/deploy.sh
PHP_BIN="${PHP_BIN:-/usr/local/bin/php}"
DRUSH="vendor/drush/drush/drush.php"

echo "==> PHP: $("$PHP_BIN" -v | head -1)"

# drush deploy = updatedb + config:import + cache:rebuild + deploy hooks,
# in the correct order for code that just changed under our feet.
echo "==> Running drush deploy"
"$PHP_BIN" "$DRUSH" --root=web deploy -y

echo "==> Deploy complete at commit $(git rev-parse --short HEAD)"
