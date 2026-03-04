from fastapi.testclient import TestClient
import server

client = TestClient(server.app)
response = client.post('/api/signup', json={
    'email': 'test+ai@example.com',
    'password': 'password123'
})
print(response.status_code)
print(response.text)
