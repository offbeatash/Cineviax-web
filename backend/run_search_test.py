from fastapi.testclient import TestClient
import server

client = TestClient(server.app)
# create a user
token = None
r = client.post('/api/signup', json={'email':'searchtest@example.com','password':'pass123'})
print('signup', r.status_code, r.text)
if r.status_code == 200:
    token = r.json()['access_token']
else:
    print('cannot signup, abort')

if token:
    headers = {'Authorization': f'Bearer {token}'}
    r = client.get('/api/search/tmdb', params={'query':'fandry'}, headers=headers)
    print('search', r.status_code, r.text)
