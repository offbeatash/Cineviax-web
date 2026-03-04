# CI/CD Configuration Guide

## GitHub Actions Workflows

Two workflows are pre-configured to auto-deploy on push.

### Available Workflows

Located in `.github/workflows/`:
- `deploy-backend.yml` - Deploy backend to Render
- `deploy-frontend.yml` - Deploy frontend to Vercel

## Setup

### 1. GitHub Secrets Configuration

Add these secrets to your GitHub repository:

**For Backend Deployment (Render)**
1. Go to: Settings → Secrets and variables → Actions
2. Add Secret: `RENDER_SERVICE_ID`
   - Get from Render dashboard URL: `srv-xxxxx`
3. Add Secret: `RENDER_API_KEY`
   - Get from Render account settings

**For Frontend Deployment (Vercel)**
1. Go to: Settings → Secrets and variables → Actions
2. Add Secret: `VERCEL_TOKEN`
   - Generate at: https://vercel.com/account/tokens
3. Add Secret: `VERCEL_ORG_ID`
   - Get from Vercel dashboard
4. Add Secret: `VERCEL_PROJECT_ID`
   - Get from Vercel project settings

### 2. How It Works

**Backend Deployment**
```yaml
# Triggered on push to main with changes in backend/
on:
  push:
    branches: [main]
    paths:
      - 'backend/**'

# Sends webhook to Render to trigger deployment
```

**Frontend Deployment**
```yaml
# Triggered on push to main with changes in frontend/
on:
  push:
    branches: [main]
    paths:
      - 'frontend/**'

# Uses Vercel Action to deploy
```

### 3. Manual Workflows

Create `.github/workflows/manual-deploy.yml`:
```yaml
name: Manual Deploy

on:
  workflow_dispatch:  # Adds manual trigger to GitHub Actions

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy Backend
        run: curl https://api.render.com/deploy/srv-${{ secrets.RENDER_SERVICE_ID }}?key=${{ secrets.RENDER_API_KEY }}
      - name: Deploy Frontend
        uses: vercel/action@master
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
```

## Advanced Configurations

### Run Tests Before Deploy

```yaml
name: Test and Deploy

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: |
          cd backend
          pip install -r requirements.txt
          pytest

  deploy_backend:
    needs: test
    if: success()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy
        run: curl https://api.render.com/deploy/srv-${{ secrets.RENDER_SERVICE_ID }}?key=${{ secrets.RENDER_API_KEY }}
```

### Deploy to Multiple Environments

```yaml
name: Deploy to Staging/Production

on:
  push:
    branches: 
      - main      # Production
      - staging   # Staging

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      ENVIRONMENT: ${{ github.ref == 'refs/heads/main' && 'production' || 'staging' }}
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to ${{ env.ENVIRONMENT }}
        run: echo "Deploying to ${{ env.ENVIRONMENT }}"
```

## Troubleshooting

### Workflow Not Triggering
- Check file paths under `paths:`
- Verify branch name is `main`
- Check GitHub Secrets are set

### Deployment Fails
- Check GitHub Actions log
- Verify Render/Vercel credentials
- Test deployment manually on platform

### Concurrent Deployments
- GitHub will queue workflows
- Render/Vercel use latest deployment
- No conflicts expected

## Monitoring Deployments

1. Go to repository → Actions tab
2. See all workflow runs
3. Click run to see details
4. Check for errors in logs

## Disabling Auto-Deploy

Remove or comment out workflows in `.github/workflows/`

## Custom Deployment Logic

Edit `.github/workflows/` files to:
- Add approval steps
- Run tests before deploy
- Deploy to multiple services
- Send notifications
- Run database migrations

## Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Render Deployment API](https://render.com/docs/deploy-webhook)
- [Vercel GitHub Action](https://github.com/vercel/action)
- [Docker in Actions](https://docs.github.com/en/actions/publishing-packages/publishing-docker-images)
