# SaS Dev Container

Development container for [mpetricone/SaS](https://github.com/mpetricone/SaS) — a Rails 8.1 CRM/billing/ticketing app on Ruby 3.4.

## Services

| Service    | Image                          | Purpose                                        |
|------------|--------------------------------|------------------------------------------------|
| `app`      | Custom (`ruby:3.4-bookworm`)   | Rails 8.1 app (Ruby 3.4, Node 22, Yarn)        |
| `db`       | `mariadb:11`                   | MySQL-compatible primary database              |
| `selenium` | `selenium/standalone-chromium` | Remote Chrome for Capybara system tests        |

## Setup

### Prerequisites
- [VS Code](https://code.visualstudio.com/) with the **Dev Containers** extension
- Docker Desktop (or Docker Engine + Compose v2)

### Steps

1. **Clone the repo** and place the `.devcontainer/` folder at the project root.

2. **Copy config files** into your Rails project:
   ```
   .devcontainer/
   ├── devcontainer.json
   ├── docker-compose.yml
   ├── Dockerfile
   ├── post-create.sh
   └── README.md               ← this file

   config/database.yml         ← replace or merge with existing
   test/application_system_test_case.rb  ← replace Rails default
   ```

3. **Open in container**: `Ctrl/Cmd+Shift+P` → _Dev Containers: Reopen in Container_

   The `post-create.sh` script will automatically run `bundle install`,
   `yarn install`, and set up both the development and test databases.

4. **Start the dev server**:
   ```bash
   bin/serve        # uses Procfile.dev via foreman
   # or
   rails server
   ```

5. **Run tests**:
   ```bash
   rails test              # unit + integration tests
   rails test:system       # Capybara / Selenium system tests
   ```

## Watching system tests live

While system tests run, open **http://localhost:7900** in your browser.  
You'll see a live Chrome window driven by Selenium — no password required.

To run headless instead (faster, no VNC rendering), uncomment the
`--headless=new` line in `test/application_system_test_case.rb`.

## Environment variables

| Variable               | Default                       | Description                               |
|------------------------|-------------------------------|-------------------------------------------|
| `MYSQL_HOST`           | `db`                          | MariaDB service hostname                  |
| `MYSQL_PORT`           | `3306`                        | MariaDB port                              |
| `MYSQL_USER`           | `rails`                       | Database username                         |
| `MYSQL_PASSWORD`       | `rails`                       | Database password                         |
| `SELENIUM_REMOTE_URL`  | `http://selenium:4444/wd/hub` | Selenium Grid WebDriver endpoint          |
| `CAPYBARA_SERVER_HOST` | `0.0.0.0`                     | Puma test server bind address             |

## Timing / flaky test note

The README mentions some system tests may fail due to timing issues.
`Capybara.default_max_wait_time` is set to **8 seconds** in
`application_system_test_case.rb` to give the remote driver extra
headroom. Increase it further if needed, or add explicit
`have_css` / `have_text` waits in specific tests.

## Connecting to the database from your host

MariaDB is exposed on `localhost:3306`.  
Credentials: user `rails`, password `rails`, root password `root`.
