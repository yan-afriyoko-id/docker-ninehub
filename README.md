# Docker NineHub - Multi-Application Setup

Repository ini berisi setup Docker untuk menjalankan semua aplikasi NineHub (Laravel, Next.js, Vue.js, React) dengan mudah menggunakan Docker dan domain `ninehub.test`.

## 🚀 Quick Start

### Prerequisites
- Docker
- Docker Compose

### Setup Otomatis
```bash
# Setup hosts file (perlu sudo)
sudo ./setup-hosts.sh

# Jalankan script setup otomatis
./setup.sh
```

### Setup Manual

1. **Clone repository dan masuk ke direktori**
```bash
cd docker-ninehub
```

2. **Setup hosts file untuk domain ninehub.test**
```bash
sudo ./setup-hosts.sh
```

3. **Buat file .env untuk Laravel**
```bash
# Copy dari .env.example (jika ada)
cp apps/project-ninehub/.env.example apps/project-ninehub/.env

# Atau buat manual dengan konfigurasi Docker
```

4. **Set permissions**
```bash
chmod -R 755 apps/project-ninehub/storage
chmod -R 755 apps/project-ninehub/bootstrap/cache
```

5. **Build dan jalankan containers**
```bash
docker-compose up -d --build
```

6. **Setup semua aplikasi**
```bash
# Laravel
docker-compose exec laravel-app composer install
docker-compose exec laravel-app php artisan key:generate
docker-compose exec laravel-app php artisan migrate

# Next.js
docker-compose exec nextjs-app npm install

# Vue.js
docker-compose exec vue-app npm install

# React
docker-compose exec react-app npm install
```

## 🌐 Akses Aplikasi

- **Main Domain**: http://ninehub.test
- **Laravel App**: http://laravel.ninehub.test
- **Next.js App**: http://nextjs.ninehub.test
- **Vue.js App**: http://vue.ninehub.test
- **React App**: http://react.ninehub.test
- **Database**: localhost:3306
  - Database: `ninehub_db`
  - Username: `ninehub_user`
  - Password: `secret`
- **Redis**: localhost:6379

## 📁 Struktur Docker

```
docker-ninehub/
├── docker-compose.yml          # Konfigurasi Docker Compose
├── Dockerfile                  # Docker image untuk PHP Laravel
├── setup.sh                   # Script setup otomatis
├── setup-hosts.sh             # Script setup hosts file
├── docker/
│   ├── nginx/
│   │   ├── nginx.conf         # Konfigurasi Nginx utama
│   │   └── conf.d/
│   │       └── app.conf       # Konfigurasi virtual hosts
│   ├── php/
│   │   └── local.ini          # Konfigurasi PHP
│   └── mysql/
│       └── my.cnf             # Konfigurasi MySQL
└── apps/
    ├── project-ninehub/       # Aplikasi Laravel
    ├── ninehub-saas-nextjs/   # Aplikasi Next.js
    ├── vue-crm-ninehub/       # Aplikasi Vue.js
    └── reactjs-chatbot/       # Aplikasi React
```

## 🐳 Services

### 1. **laravel-app** (PHP Laravel)
- **Image**: Custom PHP 8.2-FPM
- **Port**: 9000 (internal)
- **Volume**: `./apps/project-ninehub:/var/www`

### 2. **nextjs-app** (Next.js)
- **Image**: Custom Node.js 18
- **Port**: 3000 (internal)
- **Volume**: `./apps/ninehub-saas-nextjs:/app`

### 3. **vue-app** (Vue.js)
- **Image**: Custom Node.js 18
- **Port**: 8080 (internal)
- **Volume**: `./apps/vue-crm-ninehub:/app`

### 4. **react-app** (React)
- **Image**: Custom Node.js 18
- **Port**: 3000 (internal)
- **Volume**: `./apps/reactjs-chatbot:/app`

### 5. **nginx-proxy** (Nginx Reverse Proxy)
- **Image**: nginx:alpine
- **Port**: 80:80
- **Domains**: ninehub.test, laravel.ninehub.test, nextjs.ninehub.test, vue.ninehub.test, react.ninehub.test

### 6. **db** (MySQL)
- **Image**: mysql:8.0
- **Port**: 3306:3306
- **Database**: ninehub_db
- **User**: ninehub_user
- **Password**: secret

### 7. **redis** (Redis)
- **Image**: redis:alpine
- **Port**: 6379:6379

## 🔧 Perintah Docker yang Berguna

```bash
# Lihat status containers
docker-compose ps

# Lihat logs
docker-compose logs -f

# Masuk ke container Laravel
docker-compose exec app bash

# Masuk ke container MySQL
docker-compose exec db mysql -u ninehub_user -p ninehub_db

# Restart services
docker-compose restart

# Stop semua services
docker-compose down

# Stop dan hapus volumes
docker-compose down -v
```

## 🛠️ Perintah Laravel di Docker

```bash
# Install package baru
docker-compose exec app composer require package-name

# Run artisan commands
docker-compose exec app php artisan migrate
docker-compose exec app php artisan make:controller ControllerName
docker-compose exec app php artisan make:model ModelName -m

# Clear caches
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear

# Run tests
docker-compose exec app php artisan test
```

## 🔍 Troubleshooting

### 1. Permission Issues
```bash
# Set permissions untuk storage dan cache
chmod -R 755 apps/project-ninehub/storage
chmod -R 755 apps/project-ninehub/bootstrap/cache
```

### 2. Database Connection Issues
- Pastikan container MySQL sudah running
- Cek konfigurasi database di `.env`
- Pastikan database `ninehub_db` sudah dibuat

### 3. Port Already in Use
```bash
# Cek port yang digunakan
sudo lsof -i :8000
sudo lsof -i :3306

# Stop service yang menggunakan port tersebut
```

### 4. Container Tidak Start
```bash
# Lihat logs untuk debugging
docker-compose logs app
docker-compose logs webserver
docker-compose logs db
```

## 📝 Notes

- Semua perubahan kode Laravel akan langsung ter-reflect karena menggunakan volume mounting
- Database data akan tersimpan di Docker volume `dbdata`
- Untuk production, pastikan untuk mengubah konfigurasi security di `.env`

## 🤝 Contributing

1. Fork repository
2. Buat feature branch
3. Commit changes
4. Push ke branch
5. Buat Pull Request

## 📄 License

MIT License - lihat file LICENSE untuk detail. 