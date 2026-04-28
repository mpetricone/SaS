# SaS — Service and Support CRM

SaS is a Ruby on Rails CRM for small service businesses. It includes customer management, ticketing, basic accounting, and audit logging. Resource usage is modest enough to run on modest hardware or in a container.

> **Security note:** SaS has not been subject to extensive vulnerability testing. It is intended for use on a trusted internal network only.

---

## Stack

| Component | Version |
|---|---|
| Ruby | 3.4 |
| Rails | 8.1 |
| Database | MariaDB / MySQL |
| JS bundler | Yarn + jsbundling (webpack) |
| Image processing | libvips |

---

## Development setup

### Prerequisites

- Ruby 3.4+
- Node.js 22+
- Yarn 1.22+
- MariaDB or MySQL
- libvips
- Chrome or Chromium (for system tests)

A `.devcontainer` configuration is included for VS Code / Dev Containers — it provides a matching Ruby 3.4 / Debian Bookworm environment with all dependencies pre-installed.

### First-time setup

```bash
bundle install
yarn install

# Create and migrate the development and test databases
rails db:create db:migrate db:seed
RAILS_ENV=test rails db:create db:migrate
```

`db:seed` populates required lookup data (ticket statuses, work types, standings, etc.). It is safe to re-run.

### Branding

Replace `app/assets/images/logos/corp_logo.png` with your own logo. This image is used throughout the UI, and emails.

### Running the dev server

```bash
bin/serve
# optionally: bin/serve 0.0.0.0 3000
```

This uses foreman to start Rails and the JS watcher together (`Procfile.dev`). The `gem foreman` must be installed (`gem install foreman`).

### Running the test suite

```bash
rails test
```

Some Capybara/Selenium system tests include navigation waits for Turbo. Occasional timing failures are a known issue.

---

## Production deployment (Docker)

The production environment runs as two containers — the Rails app and MariaDB — orchestrated by `compose.prod.yml`. The application source is cloned from git at image build time.

### Prerequisites on the host

- Docker 23+ (BuildKit enabled by default)
- An SSH key with read access to the git repository
- A directory for Active Storage uploads (can be an SMB mount)

### 1. Create the environment file

```bash
cp .env.production.example .env.production
```

Edit `.env.production` and fill in all values:

| Variable | Description |
|---|---|
| `SECRET_KEY_BASE` | Rails secret — generate with `openssl rand -hex 64` |
| `MYSQL_ROOT_PASSWORD` | MariaDB root password |
| `MYSQL_USER` | App database user |
| `MYSQL_PASSWORD` | App database password |
| `SAS_STORAGE_PATH` | Absolute host path for Active Storage uploads |
| `APP_HOST` | Hostname used in mailer URLs (e.g. `sas.example.lan`) |
| `APP_PROTOCOL` | `http` or `https` |
| `SMTP_*` | SMTP relay settings |
| `GIT_REPO_URL` | SSH URL of the repository (e.g. `git@host:/path/repo.git`) |
| `GIT_BRANCH` | Branch to build from (default: `master`) |
| `GIT_SSH_KEY_PATH` | Absolute host path to the SSH private key for git access |

### 2. Prepare the storage directory

The app runs as uid 1000 inside the container. The storage path on the host must be owned by that uid:

```bash
sudo mkdir -p /your/storage/path
sudo chown -R 1000:1000 /your/storage/path
```

### 3. Build and start

```bash
docker compose --env-file .env.production -f compose.prod.yml up -d --build
```

To force a full rebuild without the Docker layer cache:

```bash
docker compose --env-file .env.production -f compose.prod.yml build --no-cache
docker compose --env-file .env.production -f compose.prod.yml up -d
```

### 4. First-run database setup

After the containers are up for the first time, run migrations and seed:

```bash
docker exec -it cecil-app-1 ./bin/rails db:migrate db:seed
```

### Updating to a new version

Push your changes to the git branch configured in `GIT_BRANCH`, then rebuild:

```bash
docker compose --env-file .env.production -f compose.prod.yml build --no-cache
docker compose --env-file .env.production -f compose.prod.yml up -d
```

---

## Database backups

Dump the production database from the running container:

```bash
docker exec cecil-db-1 mariadb-dump --defaults-file=/root/.my.cnf sas_production > sas_production_$(date +%Y%m%d).sql
```

To automate, add a cron entry on the host (runs at 2 AM daily, retains 30 days):

```
0 2 * * * docker exec cecil-db-1 mariadb-dump --defaults-file=/root/.my.cnf sas_production > /var/backups/sas/sas_production_$(date +\%Y\%m\%d).sql
0 2 * * * find /var/backups/sas -name "*.sql" -mtime +30 -delete
```

Store credentials in `/root/.my.cnf` (mode 600) rather than on the command line:

```ini
[client]
user=root
password=yourpassword
```

To restore:

```bash
docker exec -i cecil-db-1 mariadb -u root -p sas_production < sas_production_20260101.sql
```

---

## Version

Version info is in `app/lib/version/version.rb`.

Copyright 2015–2026 Matthew Petricone
