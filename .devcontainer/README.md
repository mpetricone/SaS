# SaS Dev Container

Development container for [mpetricone/SaS](https://github.com/mpetricone/SaS)

## Services

| Service    | Image                          | Purpose                                        |
|------------|--------------------------------|------------------------------------------------|
| `app`      | Custom (`ruby:3.4-bookworm`)   | Rails 8.1 app (Ruby 3.4, Node 22, Yarn)        |
| `db`       | `mariadb:11`                   | MySQL-compatible primary database              |
| `selenium` | `selenium/standalone-chromium` | Remote Chrome for Capybara system tests        |

## Setup

### Prerequisites
- Docker Desktop (or Docker Engine + Compose v2) or podman & podman compose. I use podman in dev.

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

    These have largely been fixed, but you may see an occaisonal failure due to timing issues.
