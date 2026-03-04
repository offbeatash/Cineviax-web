# MongoDB Atlas Setup (Quick guide)

This document shows the minimal steps to create a free MongoDB Atlas cluster and obtain a connection string to use in production deployments (Vercel / Render / Railway / Fly).

1) Create an Atlas account
- Open https://www.mongodb.com/cloud/atlas and sign up for a free account.

2) Create a new project and cluster
- Create a new Project (name it `cineviax` or similar).
- Click "Build a Cluster" → Choose the free tier (Shared Cluster).
- Choose a cloud provider and region near your deployment (e.g., AWS us-east-1).
- Create the cluster (it may take a few minutes).

3) Create a database user (for the cluster)
- In the Atlas UI, go to "Database Access" → "Add New Database User".
- Choose a username (e.g. `cineviax_user`) and a secure password.
- Assign role: `readWriteAnyDatabase` or a more restrictive role for your app DB.

4) Network Access (IP Whitelist)
- Go to "Network Access" → "Add IP Address".
- For testing you can allow your IP or allow access from anywhere (0.0.0.0/0) — for production prefer VPC peering or specific IPs.

5) Get your connection string (SRV)
- In the Atlas Cluster view, click "Connect" → "Connect your application".
- Copy the supplied connection string (starts with `mongodb+srv://`).

Example SRV connection string (do NOT commit credentials):
```
mongodb+srv://<cluster-host>/<dbname>?retryWrites=true&w=majority
```

6) Update `backend/.env` or set platform env vars
- Locally: update `backend/.env` (do NOT commit it):
```
MONGO_URL=mongodb+srv://<cluster-host>/cineviax?retryWrites=true&w=majority
DB_NAME=cineviax
SECRET_KEY=<your-secret-key>
```

- In Render/Heroku/Vercel: set `MONGO_URL` and `DB_NAME` as environment secrets in the service settings.

7) Testing
- From your machine, test connecting with `mongosh` or the Python test script:

```powershell
# using mongosh (if installed locally)
mongosh "mongodb+srv://<cluster-host>/cineviax?retryWrites=true&w=majority"

# using Python test script
cd backend
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python test_db.py
```

8) Notes for deployments
- When deploying on Vercel or Render, set `MONGO_URL` as a secret (do not include in repo).
- Ensure the deployed service's IP is allowed in Atlas Network Access (or allow access from anywhere during initial testing).

9) Production checklist
- Rotate credentials periodically.
- Use a strong `SECRET_KEY` value for JWTs.
- Restrict IP access for Atlas (do not keep 0.0.0.0/0 in production).
- Monitor cluster metrics in Atlas.

If you want, I can create the Atlas cluster for you (I can't create accounts on your behalf), but I can provide copy-paste commands and a step-by-step checklist to follow. Once you provide the SRV connection string, I will update `backend/.env.example` and the CI workflow placeholders for deployment.
