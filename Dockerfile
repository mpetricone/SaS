# syntax = docker/dockerfile:1

# Matches .devcontainer: Ruby 3.4 on Debian Bookworm.
ARG RUBY_VERSION=3.4
FROM docker.io/library/ruby:${RUBY_VERSION}-slim-bookworm AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# Runtime-only system packages.
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
      curl \
      libvips \
      libyaml-0-2 \
      default-mysql-client \
      tzdata \
 && rm -rf /var/lib/apt/lists/*

# ── Build stage ───────────────────────────────────────────────────────────────
FROM base AS build

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
      build-essential \
      git \
      openssh-client \
      pkg-config \
      libyaml-dev \
      libvips-dev \
      default-libmysqlclient-dev \
 && rm -rf /var/lib/apt/lists/*

# Node 22 + Yarn classic (matches package.json: "yarn": "^1.22.19")
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --no-install-recommends -y nodejs \
 && npm install -g yarn \
 && rm -rf /var/lib/apt/lists/*

# Clone the application source via SSH.
# GIT_REPO_URL is an SSH-style URL (e.g. git@gitstore:/data/git/repo.git).
# GIT_SSH_KEY is injected as a BuildKit secret so the private key never appears in image layers.
ARG GIT_REPO_URL
ARG GIT_BRANCH=master

RUN --mount=type=secret,id=git_ssh_key \
    GIT_SSH_COMMAND="ssh -i /run/secrets/git_ssh_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    git clone \
      --branch "${GIT_BRANCH}" \
      --depth 1 \
      "${GIT_REPO_URL}" \
      .

# Install gems
RUN bundle install \
 && rm -rf "${BUNDLE_PATH}"/ruby/*/cache

# Install JS deps
RUN yarn install --frozen-lockfile

# Compile JS/CSS bundles (webpack via jsbundling) + digest assets.
# SECRET_KEY_BASE_DUMMY lets the Rails env boot without a real secret here.
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Drop artefacts not needed at runtime
RUN rm -rf node_modules tmp/cache

# ── Runtime stage ─────────────────────────────────────────────────────────────
FROM base

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails \
 && useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash \
 && mkdir -p /rails/log /rails/tmp /rails/storage \
 && chown -R rails:rails /rails/db /rails/log /rails/tmp /rails/storage
USER rails:rails

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
