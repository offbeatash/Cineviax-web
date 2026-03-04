# Cineviax Deployment Guide 🚀

This guide will help you deploy both the **Cineviax frontend** and **backend** to free platforms.

## Project Structure

- **Frontend**: Expo React Native web app (can run on web/mobile)
- **Backend**: FastAPI Python server with MongoDB
- **Database**: MongoDB Atlas (free tier available)

---

## 📋 Prerequisites

1. GitHub account (for connecting repositories)
2. Free MongoDB Atlas account (for database)
3. Free accounts on your chosen deployment platforms
4. Git installed locally

---

## Option 1: RECOMMENDED SETUP (Vercel + Render)

### ✅ Best for: Production-ready, feature-rich, free tier

**Frontend**: Vercel (Edge Network, 100GB/month)  
**Backend**: Render (Free tier with limited resources)  
**Database**: MongoDB Atlas (512MB free)

### Backend Setup (Render)

1. **Create MongoDB Atlas Database** (Free)
   - Go to https://www.mongodb.com/cloud/atlas
   - Sign up for free
   - Create a new cluster (Select "Free" tier)
   - Get your connection string from Atlas and keep credentials outside docs/code.
   - Example safe format: `mongodb+srv://<cluster-host>/<database>?retryWrites=true&w=majority`

2. **Deploy Backend on Render**
   - Push your code to GitHub (with `backend/` folder)
   - Go to https://render.com
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Configure:
     - **Name**: `cineviax-api`
     - **Environment**: `Docker`
     - **Build Command**: (leave blank, uses Dockerfile)
     - **Start Command**: (leave blank, uses Dockerfile)
   - Add Environment Variables:
     ```
     MONGO_URL=mongodb+srv://<cluster-host>/<database>?retryWrites=true&w=majority
     DB_NAME=cineviax
     SECRET_KEY=your-secure-random-string-here
     ```
   - Deploy (free tier gives you 1 free web service + 0.5GB RAM)
   - Get your backend URL: `https://cineviax-api.onrender.com`

3. **Update Frontend .env**
   ```bash
   EXPO_PUBLIC_API_URL=https://cineviax-api.onrender.com
   ```

### Frontend Setup (Vercel)

1. **Update Environment Variables**
   - Create `.env.production` in frontend folder:
     ```
     EXPO_PUBLIC_API_URL=https://cineviax-api.onrender.com
     ```

2. **Deploy to Vercel**
   - Go to https://vercel.com
   - Sign up/Login with GitHub
   - Click "New Project"
   - Import your `Cineviax-web` repository
   - Configure:
     - **Framework Preset**: Other
     - **Root Directory**: `frontend`
     - **Build Command**: `npm run build`
     - **Output Directory**: `dist`
   - Add Environment Variables:
     ```
     EXPO_PUBLIC_API_URL=https://cineviax-api.onrender.com
     ```
   - Deploy!
   - Get your frontend URL: `https://cineviax-web.vercel.app`

---

## Option 2: Netlify + Railway

**Frontend**: Netlify (Free tier, 100GB/month bandwidth)  
**Backend**: Railway (Free $5/month credit)  
**Database**: MongoDB Atlas

### Backend Setup (Railway)

1. Go to https://railway.app
2. Create new project
3. Select "Deploy from Dockerfile"
4. Connect GitHub repository
5. Configure environment variables (same as Render)
6. Deploy (free $5/month credit)

### Frontend Setup (Netlify)

1. Go to https://netlify.com
2. Connect GitHub repository
3. Build settings:
   - **Base Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Publish Directory**: `dist`
4. Deploy

---

## Option 3: Fly.io (Full Stack)

**Frontend**: Fly.io (Distributed globally)  
**Backend**: Fly.io  
**Database**: MongoDB Atlas

### Install Fly CLI
```bash
# macOS
brew install flyctl

# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex
```

### Deploy Backend
```bash
cd backend
flyctl launch
# Follow prompts to configure
flyctl deploy
```

### Deploy Frontend
```bash
cd frontend
flyctl launch
# Follow prompts to configure
flyctl deploy
```

---

## 🔒 Security Configuration

### Backend (.env file)

1. **Generate a random SECRET_KEY**:
   ```bash
   # Using Python
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

2. **MongoDB Connection String**
   - Never commit `.env` file to GitHub
   - Use `.env.example` as template
   - Add environment variables through platform dashboards

3. **CORS Settings**
   - Current setup allows all origins (for development)
   - Update in `backend/server.py` before production:
     ```python
     allow_origins=["https://your-frontend-url.vercel.app"]
     ```

---

## 🧪 Testing Deployment

### Test Frontend
```bash
cd frontend
npm install
npm run build
npm start  # Test build locally
```

### Test Backend Locally
```bash
cd backend
pip install -r requirements.txt
python -m uvicorn server:app --reload
```

---

## 📊 Comparing Free Tiers

| Platform | Frontend | Backend | Database | Limitations |
|----------|----------|---------|----------|------------|
| **Vercel + Render** | ✅ 100GB/mo | ✅ Limited CPU | ✅ 512MB | Best for small projects |
| **Netlify + Railway** | ✅ 100GB/mo | ✅ $5/mo credit | ✅ 512MB | Railway credit limited |
| **Fly.io** | ✅ Global | ✅ Shared CPU | ✅ 512MB | Requires payment method |

---

## 🚀 Deployment Checklist

- [ ] Create GitHub repository with both `frontend/` and `backend/` folders
- [ ] Set up MongoDB Atlas (free cluster)
- [ ] Add `.env` to `.gitignore` (never commit secrets!)
- [ ] Copy `.env.example` to `.env` locally
- [ ] Test backend locally: `python -m uvicorn server:app --reload`
- [ ] Test frontend locally: `cd frontend && npm run build`
- [ ] Deploy backend first (get API URL)
- [ ] Update frontend `.env` with backend URL
- [ ] Deploy frontend
- [ ] Test API endpoints from deployed frontend
- [ ] Monitor logs on deployment platform
- [ ] Set up alerts/monitoring

---

## 🆘 Troubleshooting

### "Backend connection failed"
- Check `EXPO_PUBLIC_API_URL` is set correctly
- Ensure backend environment variables are set
- Check CORS settings in `backend/server.py`

### "Build failed"
- Check logs on deployment platform
- Ensure all dependencies in `requirements.txt`
- Verify Node.js/Python versions match

### "Database connection error"
- Test MongoDB connection string
- Ensure IP whitelist allows all IPs (or your platform's IP)
- Check credentials are correct

---

## 📞 Quick Links

- **Vercel**: https://vercel.com
- **Render**: https://render.com
- **Netlify**: https://netlify.com
- **Railway**: https://railway.app
- **Fly.io**: https://fly.io
- **MongoDB Atlas**: https://www.mongodb.com/cloud/atlas

---

## 🎉 Success!

Once deployed, you'll have:
- ✅ Frontend: Auto-deploys on every push (with branch previews)
- ✅ Backend: Automatically running and serving API requests
- ✅ Database: Secure MongoDB hosting
- ✅ SSL/HTTPS: Automatic on all platforms
- ✅ Custom domain: Available on all platforms

Congratulations! Your Cineviax app is now live! 🎬
