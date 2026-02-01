# jonngray-terminal

A containzerized terminal-style portfolio website which is deployed automatically on pushed changes through github actions to GCP (CloudRun)

## Components

### Source Code & CI/CD

| Component | Purpose |
|-----------|---------|
| **GitHub Repo** | `j0n-gray/jonngray-terminal` - stores code, triggers deployments |
| **GitHub Actions** | Builds Docker image on every push to `main` |
| **Workload Identity Federation** | OIDC auth between GitHub and GCP |

### GCP Infrastructure

| Component | Purpose |
|-----------|---------|
| **Artifact Registry** | Stores Docker images |
| **Cloud Run** | Serverless compute platform for containers, autoscales with traffic |

### DNS & CDN

| Component | Purpose |
|-----------|---------|
| **Cloudflare** | CDN, SSL, DDoS protection, proxies to Cloud Run |

## Request Flow

```
User types jonngray.io
         │
         ▼
┌─────────────────┐
│   Cloudflare    │  DNS + CDN + SSL
│  (Edge Server)  │
└────────┬────────┘
         ▼
┌─────────────────┐
│   Cloud Run     │  nginx serves index.html
│   (Container)   │
└────────┬────────┘
         ▼
   Terminal Portfolio
```

## Deployment Flow

```
git push origin main
         │
         ▼
┌─────────────────┐
│ GitHub Actions  │  Triggered by push
└────────┬────────┘
         ▼
┌─────────────────┐
│ OIDC Auth       │  Short-lived GCP token
└────────┬────────┘
         ▼
┌─────────────────┐
│ Docker Build    │  nginx:alpine + site files
└────────┬────────┘
         ▼
┌─────────────────┐
│ Artifact        │  Push image
│ Registry        │
└────────┬────────┘
         ▼
┌─────────────────┐
│ Cloud Run       │  Zero-downtime deploy
└─────────────────┘
```

