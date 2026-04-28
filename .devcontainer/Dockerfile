# .devcontainer/Dockerfile
# Ruby 3.4 on Debian Bookworm — matches SaS runtime requirements exactly.
FROM docker.io/library/ruby:3.4-bookworm

# ── System dependencies ───────────────────────────────────────────────────────
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      # Build toolchain
      build-essential \
      pkg-config \
      # Git
      git \
      # MySQL / MariaDB client (trilogy gem uses libmysqlclient or mariadb-connector)
      default-libmysqlclient-dev \
      mariadb-client \
      # libvips for image_processing / ruby-vips
      libvips libvips-dev \
      # YAML parsing (needed by some native gems in Ruby 3.x)
      libyaml-dev \
      # Misc utilities
      curl \
      sudo \
      # Procfile runner used by bin/serve
      procps \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 22 LTS + Yarn ─────────────────────────────────────────────────────
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn \
    && rm -rf /var/lib/apt/lists/*

# ── Shared gem cache (persisted via Docker volume) ────────────────────────────
ENV BUNDLE_PATH=/usr/local/bundle
RUN mkdir -p $BUNDLE_PATH && chown $USERNAME:$USERNAME $BUNDLE_PATH

# ── Bundler + Rails 8.1 ───────────────────────────────────────────────────────
RUN gem update --system && gem install bundler --no-document

WORKDIR /workspace
USER $USERNAME
