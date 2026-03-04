# 🎬 Cineviax - Movie Watchlist Manager

A modern web application to manage your movie and TV show watchlists. Built with React Native (Expo) for the frontend and FastAPI for the backend.

## ✨ Features

- 📝 **User Authentication**: Secure signup and login with JWT tokens
- 🎥 **Movie Search**: Search for movies and TV shows via TMDB API
- 📋 **Watchlist Management**: Add/remove movies from watchlist
- ✅ **Watch Tracking**: Mark movies as watched and add personal ratings
- 🎨 **Beautiful UI**: Modern, responsive design
- 🔒 **Secure**: Password hashing, JWT authentication, CORS security
- ☁️ **Cloud Ready**: Easily deployable on Vercel, Render, Railway, Netlify, Fly.io

## 🚀 Quick Start

### Local Development (5 minutes)

Read the [QUICKSTART.md](./QUICKSTART.md) guide for detailed setup instructions.

**TL;DR with Docker:**
```bash
docker-compose up --build
# Frontend: http://localhost:3000
# Backend: http://localhost:8000
```

### Deploy to Production

Follow the [DEPLOYMENT.md](./DEPLOYMENT.md) guide for production deployment.

**Recommended Setup:**
- Frontend: [Vercel](https://vercel.com) (free, auto-deploys on push)
- Backend: [Render](https://render.com) (free tier, easy setup)
- Database: [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) (512MB free)

## 🛠️ Tech Stack

### Frontend
- **Framework**: React 19 + React Native
- **Router**: Expo Router (file-based routing)
- **Type Safety**: TypeScript
- **Styling**: React Native (cross-platform)
- **Build**: Expo (web, iOS, Android)
- **HTTP Client**: Axios

### Backend
- **Framework**: FastAPI (Python 3.11)
- **Database**: MongoDB (NoSQL)
- **Authentication**: JWT + BCrypt
- **HTTP Server**: Uvicorn
- **ORM**: Motor (async MongoDB driver)

### DevOps
- **Containerization**: Docker & Docker Compose
- **CI/CD**: GitHub Actions (ready to deploy)
- **Platforms**: Vercel, Render, Railway, Netlify, Fly.io

## 📁 Project Structure

```
cineviax-web/
├── frontend/                 # React Native (Expo) web app
│   ├── app/                 # App router structure
│   │   ├── auth/           # Login, signup screens
│   │   ├── main/           # Watchlist, watched screens
│   │   ├── _layout.tsx     # Root layout
│   │   └── index.tsx       # Home screen
│   ├── contexts/           # AuthContext for state management
│   ├── assets/             # Images, fonts
│   ├── package.json        # Frontend dependencies
│   └── Dockerfile          # Docker image for frontend
├── backend/                 # FastAPI Python server
│   ├── server.py           # Main app with routes
│   ├── requirements.txt     # Python dependencies
│   ├── Dockerfile          # Docker image for backend
│   └── .env.example        # Environment template
├── docker-compose.yml      # Full stack local development
├── QUICKSTART.md           # Local development setup
├── DEPLOYMENT.md           # Production deployment guide
└── README.md               # This file
```

## 🔌 API Endpoints

Base URL: `/api`

### Authentication
- `POST /signup` - Register new user
- `POST /login` - Login and get JWT token

### Movies (Requires JWT)
- `GET /movies` - Get user's watchlist
- `POST /movies` - Add movie
- `PUT /movies/{id}` - Update movie (mark watched, rate)
- `DELETE /movies/{id}` - Remove movie

### Search (Requires JWT)
- `GET /search/tmdb?query=<name>` - Search TMDB database

All endpoints require `Authorization: Bearer <token>` header (except auth endpoints)

## 🔐 Security Features

- ✅ **JWT Authentication**: Secure token-based auth
- ✅ **Password Hashing**: BCrypt for password security
- ✅ **CORS Protection**: Configurable origin whitelist
- ✅ **Environment Variables**: Never commit secrets
- ✅ **HTTPS Ready**: All deployment platforms include SSL/TLS
- ✅ **SQL Injection Safe**: MongoDB + Pydantic validation

## 📊 Database Schema

### Users Collection
```javascript
{
  id: UUID,
  email: String (unique),
  password_hash: Bcrypt,
  created_at: DateTime
}
```

### Movies Collection
```javascript
{
  id: UUID,
  user_id: String (foreign key),
  tmdb_id: Number,
  title: String,
  poster_path: String,
  poster_base64: String (encoded),
  tmdb_rating: Float,
  genres: [String],
  year: String,
  media_type: "movie" | "tv",
  watched: Boolean,
  personal_rating: 1-10,
  watch_date: DateTime,
  added_at: DateTime
}
```

## 🧪 Testing

### Run Backend Tests
```bash
cd backend
pytest
```

### Run Linting & Type Checks
```bash
cd backend
black .        # Format code
flake8 .       # Lint
mypy server.py # Type check
```

## 🌐 Deployment Platforms Comparison

| Platform | Frontend | Backend | Free Tier | Best For |
|----------|----------|---------|-----------|----------|
| **Vercel** | ✅ | ❌ | 100GB/mo | Fastest frontend deployment |
| **Render** | ⚠️ | ✅ | Limited | Python backend |
| **Railway** | ✅ | ✅ | $5/mo | Full-stack simplicity |
| **Netlify** | ✅ | ❌ | 100GB/mo | Best CLI experience |
| **Fly.io** | ✅ | ✅ | Limited | Global deployment |

**Recommended**: Vercel (frontend) + Render (backend)

## 📚 Documentation

- [Quick Start Guide](./QUICKSTART.md) - Set up locally in 5 minutes
- [Deployment Guide](./DEPLOYMENT.md) - Deploy to production free platforms
- [FastAPI Docs](https://fastapi.tiangolo.com) - Backend framework
- [Expo Docs](https://docs.expo.dev) - Frontend framework
- [MongoDB Docs](https://docs.mongodb.com) - Database

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a pull request

## 📝 License

MIT License - feel free to use this project for personal or commercial purposes.

## 🎉 Status

- ✅ Fully functional web app
- ✅ Production-ready code
- ✅ Docker support
- ✅ Deployment configs for all major platforms
- ✅ Comprehensive documentation
- 🚀 Ready to deploy to the cloud!

## 🆘 Troubleshooting

Having issues? Check:
1. [QUICKSTART.md](./QUICKSTART.md) - Common local issues
2. [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment troubleshooting
3. GitHub Issues - Report bugs or ask questions

## 📞 Support

- 📧 Email support (if available)
- 🐛 Report bugs on GitHub Issues
- 💬 Discussions for questions

---

**Happy watching! 🎬✨**

Made with ❤️ for movie enthusiasts
