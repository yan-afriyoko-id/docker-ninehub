#!/bin/bash

echo "�� Setting up NineHub Multi-Application Docker Environment..."

# Check if hosts file needs to be updated
echo "🌐 Checking hosts file..."
if ! grep -q "ninehub.test" /etc/hosts; then
    echo "⚠️  Please run 'sudo ./setup-hosts.sh' to add domains to hosts file"
    echo "   This will allow you to access applications via ninehub.test domains"
fi

# Create .env file for Laravel if it doesn't exist
if [ ! -f "apps/project-ninehub/.env" ]; then
    echo "📝 Creating Laravel .env file..."
    cp apps/project-ninehub/.env.example apps/project-ninehub/.env 2>/dev/null || echo "APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://ninehub.test

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=ninehub_db
DB_USERNAME=ninehub_user
DB_PASSWORD=secret

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=\"hello@example.com\"
MAIL_FROM_NAME=\"\${APP_NAME}\"

AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=
AWS_USE_PATH_STYLE_ENDPOINT=false

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=
PUSHER_HOST=
PUSHER_PORT=443
PUSHER_SCHEME=https
PUSHER_APP_CLUSTER=mt1

VITE_APP_NAME=\"\${APP_NAME}\"
VITE_PUSHER_APP_KEY=\"\${PUSHER_APP_KEY}\"
VITE_PUSHER_HOST=\"\${PUSHER_HOST}\"
VITE_PUSHER_PORT=\"\${PUSHER_PORT}\"
VITE_PUSHER_SCHEME=\"\${PUSHER_SCHEME}\"
VITE_PUSHER_APP_CLUSTER=\"\${PUSHER_APP_CLUSTER}\"" > apps/project-ninehub/.env
fi

# Set proper permissions for Laravel
echo "🔐 Setting Laravel permissions..."
chmod -R 755 apps/project-ninehub/storage
chmod -R 755 apps/project-ninehub/bootstrap/cache

# Build and start all Docker containers
echo "🐳 Building and starting all Docker containers..."
docker-compose up -d --build

# Wait for containers to be ready
echo "⏳ Waiting for containers to be ready..."
sleep 60

# Setup Laravel
echo "📦 Setting up Laravel application..."
docker-compose exec laravel-app composer install
docker-compose exec laravel-app php artisan key:generate
docker-compose exec laravel-app php artisan migrate
docker-compose exec laravel-app php artisan config:clear
docker-compose exec laravel-app php artisan config:cache

# Setup Next.js
echo "📦 Setting up Next.js application..."
docker-compose exec nextjs-app npm install

# Setup Vue.js
echo "📦 Setting up Vue.js application..."
docker-compose exec vue-app npm install

# Setup React
echo "📦 Setting up React application..."
docker-compose exec react-app npm install

echo ""
echo "✅ Setup complete! All applications are running:"
echo ""
echo "🌐 Access your applications at:"
echo "   - Main: http://ninehub.test"
echo "   - Laravel: http://laravel.ninehub.test"
echo "   - Next.js: http://nextjs.ninehub.test"
echo "   - Vue.js: http://vue.ninehub.test"
echo "   - React: http://react.ninehub.test"
echo ""
echo "📊 Database: localhost:3306 (ninehub_db)"
echo "🔴 Redis: localhost:6379"
echo ""
echo "💡 If you can't access the domains, run: sudo ./setup-hosts.sh" 