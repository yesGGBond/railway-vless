#!/bin/sh
set -eu
UUID="${XRAY_UUID:-}"
PORT="${PORT:-8080}"
WS_PATH="${WS_PATH:-/ws}"
if [ -z "$UUID" ]; then echo "XRAY_UUID is not set" >&2; exit 1; fi
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {"clients": [{"id": "$UUID"}], "decryption": "none"},
      "streamSettings": {"network": "ws", "wsSettings": {"path": "$WS_PATH"}}
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF
echo "Starting Xray on port $PORT, WS path $WS_PATH"
exec /usr/local/bin/xray run -config /etc/xray/config.json
