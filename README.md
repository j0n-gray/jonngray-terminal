# jonngray-terminal

A terminal-style portfolio website. Lives in a nginx docker container, which is deployed automatically to CloudRun on pushed git changes through github actions.

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

