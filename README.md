# Salesforce DX — GitHub Actions + Docker CI/CD

A Salesforce DX project with Apex, Lightning Web Components (LWC), and Aura components. CI/CD is handled entirely via GitHub Actions using a custom Docker image — no CumulusCI dependency.

---

## CI/CD Overview

### Docker Image

A minimal Docker image (`node:20-slim` + Salesforce CLI) is published to GitHub Container Registry (GHCR) and used as the container for all deploy workflows.

```
ghcr.io/<owner>/sf-cli:latest
```

The image is rebuilt automatically when `Dockerfile` changes on `main`, or triggered manually via `workflow_dispatch`.

### Deploy Workflows

| Trigger | Workflow | What happens |
|---|---|---|
| Push to `feature/**` or `dev` | `deploy-dev.yml` | Deploy to Dev → then Staging (sequential) |
| Push to `staging` | `deploy-staging.yml` | Deploy to Staging only |
| Push to `main` | `deploy-production.yml` | Validate (dry-run) → Deploy to Production (manual approval required) |
| `Dockerfile` change on `main` | `docker-publish.yml` | Build and push Docker image to GHCR |

### Reusable Workflow

All deploys go through `_deploy.yml`, a reusable workflow callable with:

| Input | Description |
|---|---|
| `alias` | Org alias (`dev`, `staging`, `production`) |
| `test_level` | `NoTestRun`, `RunLocalTests` (default: `NoTestRun`) |
| `validate_only` | `true` for dry-run check-only, `false` to deploy (default: `false`) |

---

## Prerequisites

### 1. GitHub Secrets

Add these in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|---|---|
| `DEV_JWT_KEY` | JWT private key for dev org |
| `DEV_CLIENT_ID` | Connected App consumer key |
| `DEV_USERNAME` | Dev org username |
| `DEV_INSTANCE_URL` | e.g. `https://login.salesforce.com` |
| `STAGING_JWT_KEY` | JWT private key for staging org |
| `STAGING_CLIENT_ID` | Connected App consumer key |
| `STAGING_USERNAME` | Staging org username |
| `STAGING_INSTANCE_URL` | e.g. `https://login.salesforce.com` |
| `PROD_JWT_KEY` | JWT private key for production org |
| `PROD_CLIENT_ID` | Connected App consumer key |
| `PROD_USERNAME` | Production org username |
| `PROD_INSTANCE_URL` | e.g. `https://login.salesforce.com` |

### 2. GitHub Environment

Create a `production` environment in **Settings → Environments** and add a required reviewer to enable the manual approval gate before production deploys.

### 3. Connected App (per org)

Each Salesforce org needs a Connected App configured with:
- OAuth enabled with **"Use digital signatures"** checked
- Your `server.crt` (public certificate) uploaded
- The Connected App pre-authorized for the deploy username

---

## Local Development

```bash
npm install              # Install dependencies
npm run lint             # Lint Aura and LWC JS files
npm run test             # Run Jest unit tests
npm run prettier         # Format code
npm run prettier:verify  # Check formatting without writing
```

Pre-commit hooks (Husky + lint-staged) enforce Prettier, ESLint, and Jest automatically on every commit.

---

## Project Structure

```
force-app/main/default/
  classes/       # Apex classes
  triggers/      # Apex triggers
  lwc/           # Lightning Web Components
  aura/          # Aura components (legacy)
  objects/       # Custom object definitions
  flexipages/    # Lightning page layouts
.github/
  workflows/
    _deploy.yml            # Reusable deploy workflow
    deploy-dev.yml         # Dev + Staging deploy
    deploy-staging.yml     # Staging-only deploy
    deploy-production.yml  # Production deploy with approval gate
    docker-publish.yml     # Build and push Docker image
Dockerfile                 # sf CLI image definition
guardrails.md              # Project rules — must be followed
```

---

## Salesforce CLI Quick Reference

```bash
sf org login web --alias myorg
sf org create scratch --definition-file config/project-scratch-def.json --alias myorg
sf project deploy start
sf project retrieve start
sf apex run test --test-level RunLocalTests
sf org open
```
