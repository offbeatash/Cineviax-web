@echo off
REM setup-deployment.bat
REM Helper script to set up deployment (Windows version)

echo.
echo 🚀 Cineviax Deployment Setup Helper
echo ====================================
echo.

REM Check prerequisites
echo 📋 Checking prerequisites...

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Git is not installed
    exit /b 1
)
echo ✅ Git found

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do echo ✅ Node.js found: %%i

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Python is not installed
    exit /b 1
)
for /f "tokens=*" %%i in ('python --version') do echo ✅ Python found: %%i

echo.
echo 🔑 Generating Security Keys...
echo ===============================
echo.

for /f "delims=" %%i in ('python -c "import secrets; print(secrets.token_urlsafe(32))"') do set "SECRET_KEY=%%i"
echo Generated SECRET_KEY:
echo %SECRET_KEY%
echo.

REM Create backend .env if doesn't exist
if not exist "backend\.env" (
    echo Creating backend\.env from template...
    copy "backend\.env.example" "backend\.env" >nul
)

REM Create frontend .env if doesn't exist
if not exist "frontend\.env" (
    echo Creating frontend\.env from template...
    copy "frontend\.env.example" "frontend\.env" >nul
)

echo ✅ Environment files created
echo.

echo 📝 Next Steps:
echo =============
echo 1. Edit backend\.env with your MongoDB URL
echo 2. Edit frontend\.env with your API URL (initially http://localhost:8000)
echo 3. Run: docker-compose up --build
echo 4. Test at http://localhost:3000
echo.

echo 🌐 Deployment Steps:
echo ===================
echo 1. Push to GitHub: git push origin main
echo 2. Read DEPLOYMENT.md for platform-specific instructions
echo 3. Choose platform: Vercel (frontend) + Render (backend)
echo 4. Follow PRODUCTION_CHECKLIST.md
echo.

echo ✨ Setup complete!
pause
