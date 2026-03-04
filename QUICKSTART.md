# Quick Start Guide - Local Development

## Prerequisites

- Node.js 18+ and npm/yarn
- Python 3.11+
- Docker (optional, for containerized setup)
- Git

## Option 1: Local Development (Without Docker)

### Step 1: Set up MongoDB locally or cloud

**Option A: Use MongoDB Atlas (Recommended)**
```bash
# 1. Go to https://www.mongodb.com/cloud/atlas
# 2. Create free account
# 3. Create free cluster
# 4. Get connection string from Atlas (do not include credentials in docs):
#    mongodb+srv://<cluster-host>/<database>?retryWrites=true&w=majority
```

**Option B: Use Local MongoDB**
```bash
# Install MongoDB locally
# macOS: brew install mongodb-community
# Windows: Download from https://www.mongodb.com/try/download/community
# Linux: Follow https://docs.mongodb.com/manual/installation/

# Start MongoDB service
# macOS: brew services start mongodb-community
# Windows: Services > MongoDB Server (should auto-start)
# Linux: sudo systemctl start mongod
```

### Step 2: Set up Backend

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# macOS/Linux:
source venv/bin/activate
# Windows (PowerShell):
.\venv\Scripts\Activate.ps1
# Windows (Command Prompt):
venv\Scripts\activate

# Copy environment template and fill in values
cp .env.example .env

# Edit .env with your MongoDB URL
# MONGO_URL=mongodb://localhost:27017  (or your Atlas URL)
# DB_NAME=cineviax
# SECRET_KEY=your-dev-secret-key

# Install dependencies
pip install -r requirements.txt

# Run backend
python -m uvicorn server:app --reload

# Backend will run at http://localhost:8000
# API docs at http://localhost:8000/docs
```

### Step 3: Set up Frontend

```bash
cd frontend

# Copy environment template
cp .env.example .env

# Edit .env
# EXPO_PUBLIC_API_URL=http://localhost:8000

# Install dependencies
npm install
# or
yarn install

# Run web development server
npm run web
# or
yarn web

# Frontend will open at http://localhost:8081 or http://localhost:19006
```

### Step 4: Test the Application

1. Open frontend at http://localhost:8081 (or shown port)
2. Signup or login
3. Search for movies
4. Add movies to watchlist
5. Mark as watched

---

## Option 2: Docker Compose (Recommended for Production Testing)

### Prerequisites
- Docker and Docker Compose installed

### Quick Start

```bash
# From project root
docker-compose up --build

# Frontend: http://localhost:3000
# Backend: http://localhost:8000
# MongoDB: localhost:27017
```

### Docker Compose Troubleshooting

```bash
# View logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb

# Stop all services
docker-compose down

# Remove volumes (WARNING: deletes data)
docker-compose down -v

# Rebuild after code changes
docker-compose up --build
```

---

## Environment Variables

### Frontend (.env)
```env
EXPO_PUBLIC_API_URL=http://localhost:8000
```

### Backend (.env)
```env
MONGO_URL=mongodb://localhost:27017
DB_NAME=cineviax
SECRET_KEY=your-development-secret-key
HOST=0.0.0.0
PORT=8000
```

---

## Useful Commands

### Backend

```bash
# Run tests
python -m pytest

# Format code
black .

# Lint code
flake8 .

# Type check
mypy server.py

# Run with specific Python version
python3.11 -m uvicorn server:app --reload
```

### Frontend

```bash
# Lint
npm run lint

# Type check (via TSC)
npm run type-check

# Build for production
npm run build

# Clean cache
npm run reset-project
```

### Database

```bash
# Connect to local MongoDB
mongosh mongodb://localhost:27017

# Show all databases
show dbs

# Use cineviax database
use cineviax

# Show collections
show collections

# View users
db.users.find()

# View movies
db.movies.find()
```

---

## API Endpoints

All endpoints require `Authorization: Bearer <token>` header (except signup/login)

### Authentication
- `POST /api/signup` - Create new user
- `POST /api/login` - Login and get token

### Movies
- `GET /api/movies` - Get user's movies
- `POST /api/movies` - Add movie to list
- `PUT /api/movies/{id}` - Update movie (mark watched, rate)
- `DELETE /api/movies/{id}` - Remove movie

### Search
- `GET /api/search/tmdb?query=<movie_name>` - Search TMDB database

---

## Common Issues

### MongoDB Connection Failed
```
Error: Server selection timed out
```
**Solution:**
- Check MongoDB is running locally or Atlas connection string is correct
- Verify MONGO_URL in .env
- Check network connection for Atlas

### Port Already in Use
```
Error: Address already in use :::8000
```
**Solution:**
```bash
# Find process using port 8000
lsof -i :8000  # macOS/Linux
netstat -ano | findstr :8000  # Windows

# Kill process or use different port
python -m uvicorn server:app --port 8001
```

### No Module Named 'fastapi'
```
ModuleNotFoundError: No module named 'fastapi'
```
**Solution:**
```bash
# Ensure virtual environment is activated
pip install -r requirements.txt
```

### Expo Web Not Starting
```
Error: Metro bundler failed
```
**Solution:**
```bash
npm run reset-project
npm install
npm run web
```

---

## Next Steps

1. Complete local development setup (steps above)
2. Create a GitHub repository
3. Follow [DEPLOYMENT.md](./DEPLOYMENT.md) for deployment instructions
4. Choose your platform (Vercel + Render recommended)
5. Deploy! 🎉

---

## Need Help?

- **Frontend issues**: Check [Expo documentation](https://docs.expo.dev)
- **Backend issues**: Check [FastAPI documentation](https://fastapi.tiangolo.com)
- **Database issues**: Check [MongoDB documentation](https://docs.mongodb.com)
- **Deployment**: Read [DEPLOYMENT.md](./DEPLOYMENT.md)
