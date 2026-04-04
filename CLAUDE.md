# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Salesforce DX (SFDX) project using API version 66.0. It contains Apex backend code, Lightning Web Components (LWC), and Aura components targeting a Developer Edition scratch org.

## Common Commands

### Salesforce CLI
```bash
# Authorize an org
sf org login web --alias myorg

# Create a scratch org
sf org create scratch --definition-file config/project-scratch-def.json --alias myorg

# Push source to scratch org
sf project deploy start

# Pull changes from scratch org
sf project retrieve start

# Run Apex tests
sf apex run test --test-level RunLocalTests

# Execute anonymous Apex
sf apex run --file scripts/apex/<script>.apex

# Open org in browser
sf org open
```

### JavaScript / LWC Development
```bash
npm install          # Install dependencies
npm run lint         # Lint Aura and LWC JS files
npm run test         # Run Jest unit tests
npm run test:unit:watch     # Jest in watch mode
npm run test:unit:coverage  # Jest with coverage
npm run prettier     # Format code
npm run prettier:verify  # Check formatting without writing
```

### Running a Single Test
```bash
# Run tests for a specific LWC component
npx jest force-app/main/default/lwc/<componentName>
```

## Architecture

### Source Layout
All Salesforce metadata lives under `force-app/main/default/`:
- `classes/` — Apex classes and their `.cls-meta.xml` files
- `triggers/` — Apex triggers
- `lwc/` — Lightning Web Components (modern UI framework, preferred for new development)
- `aura/` — Aura components (legacy UI framework)
- `objects/` — Custom object definitions
- `flexipages/` — Lightning page layouts

### Key Patterns
- **LWC vs Aura**: New UI components should use LWC. ESLint applies stricter Locker Service rules to Aura components.
- **Apex API version**: All Apex metadata targets v66.0 — keep new classes consistent.
- **REST testing**: `scripts/rest/` contains `.http` files for testing Salesforce REST API calls directly (used with VS Code REST Client extension).
- **Pre-commit hooks**: Husky runs `lint-staged` on commit — linting and formatting are enforced automatically.

### Code Quality
- ESLint config in `eslint.config.js` applies separate rule sets for Aura, LWC, and Jest mock files.
- Prettier is configured with `prettier-plugin-apex` and `@prettier/plugin-xml` — use `npm run prettier` before committing if not using the pre-commit hook.
- `.forceignore` excludes test files and `node_modules` from Salesforce deploys.
