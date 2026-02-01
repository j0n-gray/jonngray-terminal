# jonngray-terminal

A terminal-style portfolio website for Jonathan Gray.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 WORKFLOW                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────┐  push   ┌──────────────────┐ OIDC  ┌────────────────┐   │
│   │   jonngray   │────────▶│     GitHub       │──────▶│      GCP       │   │
│   │   (local)    │         │     Actions      │  Auth │   Workload     │   │
│   └──────────────┘         │                  │       │   Identity     │   │
│                            │  - Build Docker  │       │   Federation   │   │
│                            │  - Push image    │       │                │   │
│                            │  - Deploy        │       │                │   │
│                            └────────┬─────────┘       └────────────────┘   │
│                                     │                                       │
│                                     ▼                                       │
│                            ┌──────────────────┐       ┌────────────────┐   │
│                            │    Artifact      │       │   Cloud Run    │   │
│                            │    Registry      │──────▶│ (europe-west2) │   │
│                            │                  │       │                │   │
│                            │  Docker images   │       │ Serverless     │   │
│                            └──────────────────┘       │ compute for    │   │
│                                                       │ containers.    │   │
│                                                       │ Autoscales     │   │
│                                                       │ with traffic.  │   │
│                                                       └───────┬────────┘   │
│                                                               │            │
└───────────────────────────────────────────────────────────────┼────────────┘
                                                                │
┌───────────────────────────────────────────────────────────────┼────────────┐
│                              USER ACCESS                      │            │
├───────────────────────────────────────────────────────────────┼────────────┤
│                                                               │            │
│   ┌──────────┐  HTTPS   ┌──────────────────┐     proxy        │            │
│   │   User   │─────────▶│    Cloudflare    │──────────────────┘            │
│   │  Browser │          │                  │                               │
│   └──────────┘          │  - CDN / Cache   │                               │
│                         │  - SSL           │                               │
│      jonngray.io        │  - DDoS protect  │                               │
│                         └──────────────────┘                               │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

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
| **Service Account** | `github-actions@jonngray-portfolio` - deployment permissions |

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

## Files Structure

```
jonngray-terminal/
├── index.html              # Terminal portfolio
├── jonathan-gray-cv.pdf    # Downloadable CV
├── Dockerfile              # nginx:alpine + files
├── .dockerignore           # Excludes unnecessary files
└── .github/
    └── workflows/
        └── deploy.yml      # CI/CD pipeline
```

## Cost Estimate

| Service | Estimated Cost |
|---------|----------------|
| Cloud Run | $0 (free tier) |
| Artifact Registry | ~$0.10 |
| Cloudflare | $0 (free plan) |
| **Total** | **< $1/month** |
