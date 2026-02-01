# jonngray-terminal

A containzerized terminal-style portfolio website which is deployed automatically on pushed changes through github actions to GCP (CloudRun)


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

