#!/bin/bash

echo "🌐 Setting up hosts file for ninehub.test domains..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script needs to be run as root to modify /etc/hosts"
    echo "Please run: sudo ./setup-hosts.sh"
    exit 1
fi

# Add domains to hosts file
echo "📝 Adding domains to /etc/hosts..."

# Check if entries already exist
if grep -q "ninehub.test" /etc/hosts; then
    echo "✅ Domains already exist in /etc/hosts"
else
    echo "127.0.0.1 ninehub.test" >> /etc/hosts
    echo "127.0.0.1 laravel.ninehub.test" >> /etc/hosts
    echo "127.0.0.1 nextjs.ninehub.test" >> /etc/hosts
    echo "127.0.0.1 vue.ninehub.test" >> /etc/hosts
    echo "127.0.0.1 react.ninehub.test" >> /etc/hosts
    echo "✅ Domains added to /etc/hosts"
fi

echo "🎉 Hosts file setup complete!"
echo ""
echo "🌐 You can now access your applications at:"
echo "   - Main: http://ninehub.test"
echo "   - Laravel: http://laravel.ninehub.test"
echo "   - Next.js: http://nextjs.ninehub.test"
echo "   - Vue.js: http://vue.ninehub.test"
echo "   - React: http://react.ninehub.test" 