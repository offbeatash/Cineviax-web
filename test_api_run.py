import requests
import os

API_BASE = os.getenv("API_BASE", "http://localhost:8001")

print("Testing Cineviax API (target=", API_BASE, ")")
print("-" * 50)

try:
    print("\n1. Testing Signup Endpoint")
    response = requests.post(
        f"{API_BASE}/api/signup",
        json={"email": "test@example.com", "password": "testpass123"},
        timeout=5
    )
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        token = data['access_token']
        print(f"   ✅ SUCCESS! User registered")
        print(f"   Token (first 50 chars): {token[:50]}...")

        print("\n2. Testing Get Movies Endpoint (with token)")
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(
            f"{API_BASE}/api/movies",
            headers=headers,
            timeout=5
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            movies = response.json()
            print(f"   ✅ SUCCESS! Got {len(movies)} movies")

        print("\n3. Testing TMDB Search Endpoint")
        response = requests.get(
            f"{API_BASE}/api/search/tmdb?query=Inception",
            headers=headers,
            timeout=10
        )
        print(f"   Status: {response.status_code}")
        if response.status_code == 200:
            results = response.json()
            print(f"   ✅ SUCCESS! Found {len(results.get('results', []))} movies")
            if results.get('results'):
                first_movie = results['results'][0]
                print(f"   First result: {first_movie.get('title', 'Unknown')}")

    elif response.status_code == 400:
        print(f"   ⚠️  User already exists: {response.json()}")
        print("\n   Trying login instead...")
        response = requests.post(
            f"{API_BASE}/api/login",
            json={"email": "test@example.com", "password": "testpass123"},
            timeout=5
        )
        if response.status_code == 200:
            data = response.json()
            token = data['access_token']
            print(f"   ✅ Login successful!")
            headers = {"Authorization": f"Bearer {token}"}
            response = requests.get(
                f"{API_BASE}/api/movies",
                headers=headers,
                timeout=5
            )
            print(f"   Got {len(response.json())} movies from watchlist")
    else:
        print(f"   ❌ Error: {response.status_code}")
        print(f"   Response: {response.text}")

except requests.exceptions.ConnectionError:
    print(f"   ❌ ERROR: Cannot connect to backend at {API_BASE}")
    print("   Make sure the backend server is running!")
except Exception as e:
    print(f"   ❌ ERROR: {e}")

print("\n" + "-" * 50)
print("Testing complete!")
