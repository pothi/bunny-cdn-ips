#!/bin/bash
set -e

echo "Fetching Bunny CDN IP lists..."

# IPv4
curl -s -H "Accept: application/json" https://bunnycdn.com/api/system/edgeserverlist | \
jq -r '.[]' | sort -V > bunny-ipv4.txt

# IPv6
curl -s -H "Accept: application/json" https://bunnycdn.com/api/system/edgeserverlist/ipv6 | \
jq -r '.[]' | sort -V > bunny-ipv6.txt

# Combined
cat bunny-ipv4.txt bunny-ipv6.txt | sort -V > bunny-all.txt

# Generate Nginx real_ip configuration (stable version)
cat > bunny-real-ip.conf << 'EOF'
# Bunny CDN Real IP configuration
# Auto-generated for set_real_ip_from
# Last updated via GitHub Actions - see repo for generation date

EOF

while IFS= read -r ip; do
    if [ -n "$ip" ]; then
        echo "set_real_ip_from $ip;" >> bunny-real-ip.conf
    fi
done < bunny-all.txt

cat >> bunny-real-ip.conf << 'EOF'

real_ip_header X-Real-IP;
real_ip_recursive on;
EOF

# Hash comparison to avoid unnecessary commits
if [ -f .last-hash ]; then
    OLD_HASH=$(cat .last-hash)
    NEW_HASH=$(sha256sum bunny-*.txt bunny-real-ip.conf | sha256sum | awk '{print $1}')

    if [ "$OLD_HASH" = "$NEW_HASH" ]; then
        echo "No changes detected. Skipping commit."
        exit 0
    fi
fi

# Update hash file
sha256sum bunny-*.txt bunny-real-ip.conf | sha256sum | awk '{print $1}' > .last-hash

echo "✅ Updated Bunny CDN IP lists:"
echo "   • $(wc -l < bunny-ipv4.txt) IPv4 addresses"
echo "   • $(wc -l < bunny-ipv6.txt) IPv6 addresses"
echo "   • $(wc -l < bunny-all.txt) total addresses"
echo "   • bunny-real-ip.conf generated for Nginx"
