# SaS Development Environment

Reference document for the containerized development setup for
[mpetricone/SaS](https://github.com/mpetricone/SaS) — a Rails 8.1 / Ruby 3.4
CRM, billing, and ticketing application.

---

## Overview

The development environment runs entirely in containers. Your editor runs on the
host OS and edits files directly — the repository is bind-mounted into the app
container so there is no sync step. The containers provide Ruby, Rails, MariaDB,
and a remote Selenium/Chrome node for system tests.

```
Host OS
├── Your editor (Vim, Neovim, Zed, VS Code, anything)
├── Repository on host disk  ← you edit here
│
└── Containers (podman-compose / docker-compose)
    ├── app        Ruby 3.4, Rails 8.1, Node 22
    │              /workspace bind-mounted from host repo
    ├── db         MariaDB 11
    └── selenium   Chromium + Selenium Grid (for Capybara system tests)
```

---

## Prerequisites

- [Podman](https://podman.io/) with `podman-compose`
  ```bash
  sudo apt install podman podman-compose
  ```
- Your preferred editor installed on the host

---

## First-time setup

```bash
# 1. Clone the repository
git clone https://github.com/mpetricone/SaS.git
cd SaS

# 2. Start the container stack from the repo root
podman-compose -f .devcontainer/docker-compose.yml up -d

# 3. Wait for all containers to be healthy
podman ps

# 4. Run first-time setup inside the app container
#    (bundle install, yarn install, db:create, db:migrate, db:seed)
podman exec -it devcontainer_app_1 bash /workspace/.devcontainer/post-create.sh
```

After this, the stack only needs `up -d` on subsequent starts.

---

## Daily workflow

```bash
# Start the stack (from repo root)
podman-compose -f .devcontainer/docker-compose.yml up -d

# Open a shell in the app container
podman exec -it devcontainer_app_1 bash

# Edit files normally in your host editor — changes are instant in the container
nvim .
```

```bash
# Inside the container:

# Start the dev server (binds to 0.0.0.0:3000)
bin/serve

# Run the full test suite
bin/rails test

# Run system tests only (uses Selenium)
bin/rails test:system

# Database tasks
bin/rails db:migrate
bin/rails db:seed
RAILS_ENV=test bin/rails db:migrate
```

```bash
# Stop the stack when done
podman-compose -f .devcontainer/docker-compose.yml down
```

**Important:** always run `down` before `up` when you have made changes to
`docker-compose.yml` — running containers do not pick up config changes until
they are recreated.

---

## Accessing the app

| URL                        | Description                          |
|----------------------------|--------------------------------------|
| http://localhost:3000      | Rails dev server (`bin/serve`)       |
| http://localhost:7900      | noVNC live browser (system tests)    |

---

## Services and ports

| Service    | Host port | Description                          |
|------------|-----------|--------------------------------------|
| Rails      | 3000      | `bin/serve`                          |
| MariaDB    | 3306      | MySQL-compatible database            |
| Selenium   | 4444      | WebDriver endpoint / Grid UI         |
| noVNC      | 7900      | Live browser view during system tests|

---

## Database

MariaDB 11 runs as a container service. The app uses the `trilogy` adapter —
`mysql2` is **not** used and should not be in the Gemfile.

| Setting   | Value             |
|-----------|-------------------|
| Host      | `db` (in-container) / `127.0.0.1` (from host) |
| Port      | 3306              |
| User      | `root`            |
| Password  | `root`            |
| Dev DB    | `sas_development` |
| Test DB   | `sas_test`        |

The `root` user is used for the Rails connection to ensure it has permission
to create both the development and test databases. Connection parameters are
set via environment variables in `.devcontainer/docker-compose.yml` and read
by `config/database.yml`.

---

## Gems and native extensions

Gems with C extensions (e.g. `trilogy`, `ruby-vips`) compile against libraries
inside the container. Always run `bundle install` inside the container:

```bash
podman exec -it devcontainer_app_1 bundle install
```

Compiled gems are stored in the `bundle_cache` Podman volume and are not
written into the repository directory, so there is no conflict with any gems
installed on your host machine.

If you add a new gem to the Gemfile, run `bundle install` inside the container
and the volume will be updated automatically.

---

## Podman-specific notes

**Container names** — Podman Compose derives container names from the
`.devcontainer` directory name. Containers will be named:
- `devcontainer_app_1`
- `devcontainer_db_1`
- `devcontainer_selenium_1`

**Rootless mode** — Podman runs rootless by default. If you encounter volume
permission errors, add `userns_mode: keep-id` to the `app` service in
`.devcontainer/docker-compose.yml`.

**Fully qualified image names** — Unlike Docker, Podman on Ubuntu/Mint requires
fully qualified image names (e.g. `docker.io/library/mariadb:11` rather than
just `mariadb:11`). All images in `docker-compose.yml` are already fully
qualified.

**shm_size** — Podman on Linux may ignore `shm_size`. The Selenium service
uses a `tmpfs` mount for `/dev/shm` instead, which works reliably.

**Selenium healthcheck** — The Selenium 4.x status endpoint is `/status` not
`/wd/hub/status`, and the JSON response uses `"ready": true` with a space.
The healthcheck in `docker-compose.yml` accounts for both of these.

---

## Capybara / Selenium architecture

```
app container                         selenium container
─────────────────                     ──────────────────
Puma test server                      Chromium
  bound to 0.0.0.0:3001               Selenium Grid
  reachable via container IP   ←───   opens this URL
        ↑
Capybara sends WebDriver commands
  to http://selenium:4444
```

Key settings in `test/test_helper.rb`:

| Setting                        | Value                          | Reason                                           |
|-------------------------------|--------------------------------|--------------------------------------------------|
| `Capybara.server_host`         | `0.0.0.0`                      | Binds Puma to all interfaces                     |
| `Capybara.server_port`         | `3001`                         | Separate from dev server on 3000                 |
| `Capybara.app_host`            | `http://<container_ip>:3001`   | Uses IP not hostname to avoid Chrome HSTS issues |
| `default_max_wait_time`        | 8 seconds                      | Extra headroom for remote driver latency         |
| `SELENIUM_REMOTE_URL`          | `http://selenium:4444`         | Points to the selenium container                 |
| `options.accept_insecure_certs`| `true`                         | Allows self-signed certs                         |

**Important:** `Capybara.app_host` uses the container's IP address looked up
dynamically at runtime rather than the `app` hostname. This avoids a Chrome
HSTS cache issue where Chrome would upgrade HTTP connections to HTTPS for
previously visited hostnames. The IP is resolved in `test_helper.rb` with:

```ruby
require "socket"

app_ip = Socket.ip_address_list
           .find { |addr| addr.ipv4? && !addr.ipv4_loopback? }
           .ip_address

Capybara.app_host = "http://#{app_ip}:#{Capybara.server_port}"
```

Screenshots on test failure are saved automatically to `tmp/screenshots/`.

---

## bin/serve

The dev server script `bin/serve` starts Rails and the JS watcher via Foreman:

```bash
bin/serve          # binds to 0.0.0.0:3000 by default
bin/serve 0.0.0.0 3000  # explicit host and port
```

The default bind address was changed from `127.0.0.1` to `0.0.0.0` so the
server is reachable from the host browser at `http://localhost:3000`.

Foreman must be in the Gemfile:
```ruby
gem 'foreman', group: :development
```

And is invoked via `bundle exec` in `bin/serve` so it is found in the bundle
path regardless of what is installed globally.

---

## VS Code / Dev Containers (optional)

The `.devcontainer/devcontainer.json` is included for developers who prefer
VS Code with the Dev Containers extension. It is ignored entirely when using
the host-editor workflow described above.

To use it, install the Dev Containers extension and run:
`Ctrl/Cmd+Shift+P` → _Dev Containers: Reopen in Container_

For Podman, add to VS Code `settings.json`:
```json
"dev.containers.dockerPath": "podman",
"dev.containers.dockerComposePath": "podman-compose"
```

---

## File layout

```
SaS/
├── .devcontainer/
│   ├── devcontainer.json          VS Code Dev Containers config (optional)
│   ├── docker-compose.yml         Container stack definition
│   ├── Dockerfile                 App container image (Ruby 3.4)
│   ├── post-create.sh             First-time setup script
│   └── DEVENV.md                  This file
├── config/
│   └── database.yml               Trilogy/MySQL config (env-var driven)
├── bin/
│   └── serve                      Dev server script (0.0.0.0 default)
└── test/
    └── test_helper.rb             Capybara + remote Selenium configuration
```
