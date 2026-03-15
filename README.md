# Agentforce CI/CD

## Presentation Demo Repository

This repository contains demo material for Salesforce Agentforce CI/CD, showcasing two approaches to Agentforce DevOps.

**Presenter**: [@nabondance](https://github.com/nabondance)

---

## Demos

### agentforce-classic

**Presented at**: Paris Salesforce Dev Group — November 5th, 2025
**Title**: `Une CI/CD pour vos Agentforce : état des lieux`

Classic Agentforce CI/CD pipeline using the standard Salesforce declarative approach with scratch org pools, parallel agent testing, and automated release.

[![Slides](./agentforce-classic/resources/SlidesCover.png)](https://docs.google.com/presentation/d/1-kYRPyL2792Mu3WCTfTFenWKxlG5TSbd2vSTt9fQYrA)

Slides PDF: [pdf](./agentforce-classic/resources/Slides.pdf) | Video: [link](https://www.youtube.com/watch?v=d0er1JVcqvY)

**What it demonstrates:**
- Automated agent testing with parallel execution and dynamic test discovery
- Scratch org pool management using [@flxbl-io/sfp](https://github.com/flxbl-io/sfp)
- Quality gate: 75% test pass threshold
- GitHub Actions PR validation and release workflows
- Automated production deployment on merge

**Workflows** (`.github/workflows/agentforce-classic/`):
| Workflow | Trigger | Flow |
|----------|---------|------|
| `agentforce-validate.yml` | PR to main | Setup → Deploy → Test Discovery → Parallel Testing → Validation → Cleanup |
| `agentforce-release.yml` | PR merged to main | Authenticate → Deactivate agents → Deploy → Reactivate agents |

**Metadata & config** (`agentforce-classic/`):
- `force-app/` — Salesforce Agentforce metadata (bots, prompt templates, AI bundles)
- `manifest.xml` — Agentforce metadata manifest
- `config/` — Scratch org definition and pool configs (CI + dev)
- `scripts/` — Agent lifecycle, deployment, and pool helper scripts

---

### agentforce-script

> Work in progress

Agentforce Script DevOps demo — coming soon.

**Workflows** (`.github/workflows/agentforce-script/`): coming soon

**Metadata & config** (`agentforce-script/`):
- `force-app/` — Salesforce metadata
- `config/` — Scratch org and pool configs
- `scripts/` — Helper scripts

---

## Shared Infrastructure

### Pool Preparation (`prepare-pools.yml`)

**Triggered on**: Manual dispatch (or scheduled)

Provisions scratch org pools used by the CI pipelines.

```
Authenticate → Prepare Pools (CI & Dev) → Configure Orgs
```

To learn more about pool strategies: `How Scratch Orgs Pools Fit Into Your Salesforce Strategy`
- [Slides](https://speakerdeck.com/nabondance/frenchtouchdreamin-elevate-your-devops-how-scratch-orgs-pools-fit-into-your-salesforce-strategy)
- [Video](https://www.youtube.com/watch?v=09WEqN1emIM)

### Required GitHub Secrets

| Secret | Used by |
|--------|---------|
| `DEVHUB_SFDX_AUTH_URL` | All workflows (pool fetch, cleanup) |
| `ORG_SFDX_AUTH_URL` | Release workflow (production deploy) |

---

## Repository Structure

```
AgentforceCICD/
├── .github/
│   └── workflows/
│       ├── agentforce-classic/    # Classic demo workflows
│       ├── agentforce-script/     # Script DevOps workflows (WIP)
│       └── prepare-pools.yml      # Shared pool preparation
├── agentforce-classic/            # Classic demo — self-contained
│   ├── force-app/
│   ├── config/
│   ├── scripts/
│   ├── resources/
│   └── manifest.xml
├── agentforce-script/             # Script DevOps demo — WIP
│   ├── force-app/
│   ├── config/
│   ├── scripts/
│   └── resources/
├── sfdx-project.json
└── package.json
```

---

## Technologies

- **GitHub Actions** — CI/CD orchestration
- **Salesforce CLI** — Metadata operations and agent testing
- **@flxbl-io/sfp** — Scratch org pool management
- **pnpm** — Package management
- **Docker** — Containerized job execution

## Resources

- [Salesforce CLI Guide](https://developer.salesforce.com/tools/sfdxcli)
- [Agentforce Guide](https://www.salesforce.com/agentforce/guide/)
- [@flxbl-io/sfp Documentation](https://docs.flxbl.io/)

## Questions & Discussion

Open an issue or reach out on LinkedIn: [Nathan Abondance](https://www.linkedin.com/in/nabondance/)

---

**Note**: This is a demonstration repository. Adapt configurations to your organization's requirements before using in production.

**Maintenance**: Kept up-to-date with the latest Salesforce and Agentforce features — star/follow to stay updated.
