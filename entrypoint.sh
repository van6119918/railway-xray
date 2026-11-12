#!/bin/sh
# Railway sets $PORT; xray must listen on it. Rewrite the listen port in
# config.json from $PORT (default 3000 if unset), then start xray.
PORT=${PORT:-3000}
sed -i "s/\"port\":3000/\"port\":${PORT}/" /usr/local/etc/xray/config.json
exec /usr/local/bin/xray run -c /usr/local/etc/xray/config.json
