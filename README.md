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
| `MAIL_FROM` | "From" address for outgoing mail (password resets, quotes, invoices). Defaults to `noreply@example.com` if unset. |
| `FORCE_SSL` | `true` to enforce HTTPS / HSTS, `false` to allow plain HTTP (default: `true`). |
| `GIT_REPO_URL` | SSH URL of the repository (e.g. `git@host:/path/repo.git`) |
| `GIT_BRANCH` | Branch to build from (default: `master`) |
| `GIT_SSH_KEY_PATH` | Absolute host path to the SSH private key for git access |
| `AR_ENCRYPTION_PRIMARY_KEY` | Rails attribute-encryption primary key. Generate with `bin/rails db:encryption:init`. **Lose this and 2FA secrets become unreadable.** |
| `AR_ENCRYPTION_DETERMINISTIC_KEY` | Rails attribute-encryption deterministic key (same generator output) |
| `AR_ENCRYPTION_KEY_DERIVATION_SALT` | Rails attribute-encryption key-derivation salt (same generator output) |
| `SOLID_QUEUE_IN_PUMA` | Set to `true` to run the SolidQueue background-job worker in the Puma process. Required for password-reset emails. |

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

## Authentication & security

Employee authentication uses Rails 8's session model with bcrypt password hashing. Authorization is handled by [Pundit](https://github.com/varvet/pundit) policies under `app/policies/`, backed by the existing `Permission` / `EmployeePermission` tables — admins continue to manage per-employee permissions through the same UI.

### Login flow

| Step | Behavior |
|---|---|
| Login form | `GET /login` (or `GET /session/new`) |
| Failed login | Increments `failed_attempts`. After 10 failed attempts the account is locked for 30 minutes. |
| Successful login | Resets `failed_attempts`, clears `locked_at`, starts a new `Session` row, sets a signed `session_id` cookie (`Secure` in production, `HttpOnly`, `SameSite=Lax`). |
| 2FA-enabled account | Password success redirects to `/two_factor_challenge/new`; the session is only created after a valid TOTP or recovery code. |
| Logout | `DELETE /logout` — destroys the `Session` row and deletes the cookie. |

### Rate limiting

[Rack::Attack](https://github.com/rack/rack-attack) throttles abusive requests:

- 5 login attempts per IP per 20 seconds
- 5 login attempts per username per 20 seconds (defense against distributed-IP guessing)
- 5 password-reset requests per IP per hour

Throttled requests receive HTTP 429 and are written to the `Log` audit table with category `rack_attack_throttle`.

### Security audit events

Security-significant actions emit named events to the `logs` table with `category: "security"` via `Audit.event(:name, ...)`. This is separate from the routine per-request log written by `Auditor#auto_log` — the security stream is intentional and queryable.

Events currently emitted:

| Event | When |
|---|---|
| `login_success` | Password (and 2FA, if enabled) verified, session created |
| `login_failure` | Bad credentials, account locked, or OU disabled |
| `account_locked` | 10th consecutive failed attempt on an unlocked account |
| `account_unlocked` | Admin clicked "Unlock account" on the employee edit page |
| `logout` | Session deleted |
| `password_reset_requested` | `/passwords` POST (regardless of whether email was sent) |
| `password_reset_completed` | New password successfully set via reset token |
| `two_factor_enabled` | TOTP enrollment verified, 2FA turned on |
| `two_factor_disabled` | TOTP disabled (after password re-confirmation) |
| `two_factor_success` / `two_factor_failure` | Login-time TOTP challenge outcome |
| `admin_granted` | `rails employees:grant_admin[user_name]` rake task |

Each row's `details` column is JSON containing the IP, user agent, and event-specific context (e.g. the attempted username for failed logins).

To view the security audit trail:

```ruby
Log.where(category: "security").order(event_at: :desc)
Log.where(category: "security", in_method: "login_failure")
```

### Password reset

Employees can request a reset from the login page (`/passwords/new`). The reset link is sent via `PasswordsMailer` to the first address on file in `Contact#contact_emails`. Tokens are signed and expire after 15 minutes; changing the password invalidates any outstanding tokens. To avoid username enumeration, the response is identical whether the username exists, has an email on file, or doesn't exist at all.

Password reset emails are delivered via `deliver_later`, so SolidQueue must be running (`SOLID_QUEUE_IN_PUMA=true`).

### Two-factor authentication (TOTP)

2FA is **optional and employee-initiated**. From the navbar, an employee opens the dropdown under their name → *Account*, scans the QR code in any authenticator app (Google Authenticator, 1Password, Authy, etc.), and confirms a 6-digit code. On success, the system displays 10 one-time recovery codes — these are shown **once** and stored as bcrypt hashes, so save them at enrollment time.

To disable 2FA, the employee re-enters their current password.

`otp_secret` and `otp_recovery_codes` are encrypted at the application layer via Rails attribute encryption (see the `AR_ENCRYPTION_*` env vars above). Losing those keys makes existing 2FA secrets unreadable; users would have to re-enroll.

### Admin recovery

If you lock yourself out, two rake tasks bypass the web flow and operate directly on the database:

```bash
# Grant admin permission to an employee
docker exec -it cecil-app-1 ./bin/rails employees:grant_admin[username]

# Unlock a locked account (clears failed_attempts and locked_at)
docker exec -it cecil-app-1 ./bin/rails employees:unlock[username]
```

### Cutover from the legacy auth system

The first deploy that includes the auth revamp drops the old `authenticity_tokens` table. **Every active session is invalidated** and every employee is required to log in again. Communicate this to your users before the deploy. Their passwords are not affected — bcrypt hashes carry forward unchanged.

Steps:

1. Set the new env vars in `.env.production`: `AR_ENCRYPTION_PRIMARY_KEY`, `AR_ENCRYPTION_DETERMINISTIC_KEY`, `AR_ENCRYPTION_KEY_DERIVATION_SALT`, and `SOLID_QUEUE_IN_PUMA=true`. Generate the encryption keys with `docker exec -it cecil-app-1 ./bin/rails db:encryption:init` and copy the printed values.
2. Rebuild and start: `docker compose --env-file .env.production -f compose.prod.yml up -d --build`.
3. Run migrations: `docker exec -it cecil-app-1 ./bin/rails db:migrate`. The migration drops `authenticity_tokens`, creates `sessions` and the SolidQueue tables, and adds lockout / 2FA columns to `employees`.
4. Smoke-test login as an admin, then confirm the permission-management UI still works.

---

## Version

Version info is in `app/lib/version/version.rb`.

Copyright 2015–2026 Matthew Petricone
