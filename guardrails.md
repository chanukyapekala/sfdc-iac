# Project Guardrails

These rules are non-negotiable. Claude must not bypass, work around, or suggest bypassing any of these guardrails under any circumstances.

---

## 1. Pre-Commit Checks (mandatory before every commit)

All three must pass — no exceptions:

- **Prettier** — run `npm run prettier` to auto-fix formatting
- **ESLint** — run `npm run lint` to check Aura and LWC JS files
- **Jest** — run `npm run test:unit` to validate LWC components you touched

Never use `--no-verify` to skip the Husky pre-commit hook.

---

## 2. Secrets and Credentials

- Never hardcode credentials, JWT keys, client IDs, usernames, or instance URLs in any file
- Never commit `server.key`, `server.crt`, `.env`, or any `*.key` / `*.crt` file
- All secrets must go through GitHub Secrets only
- JWT key files must be written to `/tmp/` and deleted immediately after use in CI

---

## 3. Salesforce Deploys

- **API version** is locked at **66.0** — all new metadata `.cls-meta.xml`, triggers, LWC, etc. must use `apiVersion: 66.0`
- **Test level** for staging and production deploys must always be `RunLocalTests` minimum
- **Production** requires a dry-run validation (`--dry-run`) before the real deploy — never skip it
- **`.forceignore`** must never be modified to allow test files, `node_modules`, or config files to deploy to a Salesforce org

---

## 4. Branch and Deployment Rules

- `main` branch is **production** — only merge when ready to deploy to production
- `feature/**` and `dev` branches auto-deploy to **dev and staging** — coordinate with teammates before pushing
- Production deploys require manual approval via the GitHub `production` environment gate — never remove or bypass this gate
- Never set `cancel-in-progress: true` on staging or production concurrency groups

---

## 5. CI/CD Workflows

- Never add `--no-verify` or skip hooks in workflow steps
- Never remove the validate (dry-run) step from `deploy-production.yml`
- Never remove `needs:` dependencies between jobs — sequential order is intentional
- The `_deploy.yml` reusable workflow is the single source of deploy logic — do not duplicate deploy steps inline in other workflows
- The Docker image (`ghcr.io/<owner>/sf-cli:latest`) must be built and available before any deploy workflow runs

---

## 6. Code Quality

- New UI components must use **LWC**, not Aura
- Do not disable or override ESLint rules inline (`// eslint-disable`) without a documented reason in a comment
- Do not suppress Prettier formatting for entire files
- LWC test files live in `__tests__/` alongside the component — do not place them elsewhere

---

## 7. Git Hygiene

- Never force-push to `main`
- Never amend published commits on shared branches
- `server.key` and `server.crt` are in `.gitignore` — if they appear as untracked, do not stage them
