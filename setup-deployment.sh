#!/bin/bash
# setup-deployment.sh
# Helper script to set up deployment

set -e

echo "🚀 Cineviax Deployment Setup Helper"
echo "===================================="
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed"
    exit 1
fi
echo "✅ Git found"

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    exit 1
fi
echo "✅ Node.js found: $(node --version)"

if ! command -v python3 &> /dev/null; then
    echo "❌ Python is not installed"
    exit 1
fi
echo "✅ Python found: $(python3 --version)"

echo ""
echo "🔑 Generating Security Keys..."
echo "==============================="
echo ""

# Generate SECRET_KEY
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))")
echo "Generated SECRET_KEY:"
echo "$SECRET_KEY"
echo ""

# Create backend .env example if doesn't exist
if [ ! -f "backend/.env" ]; then
    echo "Creating backend/.env from template..."
    cp backend/.env.example backend/.env
    
    # Try to update SECRET_KEY in .env if possible
    if command -v sed &> /dev/null; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" backend/.env
        else
            sed -i "s|SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" backend/.env
        fi
    fi
fi

# Create frontend .env if doesn't exist
if [ ! -f "frontend/.env" ]; then
    echo "Creating frontend/.env from template..."
    cp frontend/.env.example frontend/.env
fi

echo "✅ Environment files created"
echo ""

echo "📝 Next Steps:"
echo "============="
echo "1. Edit backend/.env with your MongoDB URL"
echo "2. Edit frontend/.env with your API URL (initially http://localhost:8000)"
echo "3. Run: docker-compose up --build"
echo "4. Test at http://localhost:3000"
echo ""

echo "🌐 Deployment Steps:"
echo "==================="
echo "1. Push to GitHub: git push origin main"
echo "2. Read DEPLOYMENT.md for platform-specific instructions"
echo "3. Choose platform: Vercel (frontend) + Render (backend)"
echo "4. Follow PRODUCTION_CHECKLIST.md"
echo ""

echo "✨ Setup complete!"
