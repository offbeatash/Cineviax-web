# Production Deployment Checklist

## Pre-Deployment Checklist

### Security Review
- [ ] Generate new `SECRET_KEY` for production (not development key)
  ```bash
  python -c "import secrets; print(secrets.token_urlsafe(32))"
  ```
- [ ] Update CORS policy in `backend/server.py` (restrict to your domain)
- [ ] Use strong passwords for MongoDB
- [ ] Enable MongoDB VPC/IP whitelist
- [ ] Never commit `.env` file (add to `.gitignore`)
- [ ] Review environment variables on each platform

### Backend Verification
- [ ] All dependencies in `requirements.txt`
- [ ] Test build locally: `docker build backend/`
- [ ] Verify API responses with local test
- [ ] Check database connection string is correct
- [ ] Enable HTTPS on production (auto on Render/Vercel)
- [ ] Set up error logging/monitoring

### Frontend Verification
- [ ] Build locally: `npm run build`
- [ ] Test build output: `npm start`
- [ ] Update `EXPO_PUBLIC_API_URL` to production backend URL
- [ ] Remove console.log statements (if any)
- [ ] Test API calls from production frontend
- [ ] Verify responsive design on mobile

### Database Setup
- [ ] Create MongoDB Atlas account and cluster
- [ ] Create database user with strong password
- [ ] Allow IP 0.0.0.0/0 (or restrict to backend IPs)
- [ ] Create collections (auto on first insert)
- [ ] Backup plan in place

### Deployment Configuration
- [ ] Update each platform's environment variables
- [ ] GitHub repo is private (if needed)
- [ ] GitHub Actions secrets configured
- [ ] Webhook for auto-deploy set up
- [ ] Custom domain configured (optional)

## Step-by-Step Deployment

### 1. Create GitHub Repository
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/cineviax-web.git
git branch -M main
git push -u origin main
```

### 2. Set up MongoDB Atlas
1. https://www.mongodb.com/cloud/atlas
2. Create free cluster
3. Create database user
4. Get connection string format: `mongodb+srv://<cluster-host>/<dbname>?retryWrites=true&w=majority`

### 3. Deploy Backend (Render)
1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Select GitHub repository
4. Configure:
   - Runtime: Docker
   - Region: Choose closest
   - Plan: Free
5. Environment Variables:
   ```
   MONGO_URL=mongodb+srv://<cluster-host>/cineviax?retryWrites=true&w=majority
   DB_NAME=cineviax
   SECRET_KEY=<generated-key>
   ```
6. Click "Deploy"
7. Get Service URL (e.g., `https://cineviax-api.onrender.com`)

### 4. Deploy Frontend (Vercel)
1. Go to https://vercel.com
2. Click "New Project"
3. Import GitHub repository
4. Configure:
   - Framework: Other
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Install Command: `npm install`
   - Output Directory: `dist`
5. Environment Variables:
   ```
   EXPO_PUBLIC_API_URL=https://cineviax-api.onrender.com
   ```
6. Click "Deploy"
7. Get Frontend URL (e.g., `https://cineviax-web.vercel.app`)

### 5. Update CORS (If Not * )
Edit `backend/server.py`:
```python
app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["https://cineviax-web.vercel.app"],  # Your frontend URL
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### 6. Test Production Deployment
```bash
# Test signup (should work with production backend)
curl -X POST https://cineviax-api.onrender.com/api/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"testpass123"}'

# Should return: {"access_token":"...", "token_type":"bearer"}
```

## Post-Deployment

### Monitoring
- [ ] Check backend logs on Render dashboard
- [ ] Check frontend deployments on Vercel
- [ ] Monitor database usage on MongoDB Atlas
- [ ] Set up error alerts (if available)

### Performance
- [ ] Test API response times
- [ ] Check frontend load time
- [ ] Monitor database query performance
- [ ] Enable caching if needed

### Maintenance
- [ ] Keep dependencies updated
- [ ] Regular security updates
- [ ] Database backups (MongoDB Atlas auto-backups)
- [ ] Version control all changes

## Troubleshooting

### API 500 Errors
```bash
# Check backend logs on Render
# Verify environment variables are set
# Check MongoDB connection
# Review backend code for errors
```

### Frontend Can't Connect to Backend
```bash
# Verify EXPO_PUBLIC_API_URL is correct
# Check CORS settings in backend
# Ensure backend is deployed and running
# Test endpoint directly: curl https://api-url/api/movies (should 401)
```

### Database Connection Failed
```bash
# Check MONGO_URL format
# Verify IP whitelist on MongoDB Atlas
# Test connection string locally
# Check credentials
```

### Build Failures
```bash
# Check build logs on platform dashboard
# Verify all files are committed to GitHub
# Check for missing dependencies
# Ensure correct Node.js/Python versions
```

## Rollback Plan

If deployment goes wrong:
```bash
# Vercel: Use previous deployments dashboard
# Render: Restart previous release
# Or rollback Git commit: git revert <commit-hash>
```

## Performance Optimization

### Backend
- Add caching headers
- Optimize MongoDB queries
- Use connection pooling
- Enable compression

### Frontend
- Lazy load components
- Optimize images
- Enable code splitting
- Use CDN for assets

## Security Hardening

- [ ] Update CORS to specific domain
- [ ] Enable rate limiting
- [ ] Add request validation
- [ ] Monitor suspicious activity
- [ ] Keep dependencies updated
- [ ] Use strong authentication
- [ ] Enable debugging in production (off)

---

## Quick Reference

| Step | Platform | Action | Output |
|------|----------|--------|--------|
| 1 | GitHub | Push code | Repository ready |
| 2 | MongoDB | Create cluster | Connection string |
| 3 | Render | Deploy backend | API URL |
| 4 | Vercel | Deploy frontend | Frontend URL |
| 5 | All | Update configs | Production live |

---

**Checklist complete? Your app is production-ready! 🎉**
