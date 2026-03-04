import requests
try:
    r = requests.post('http://localhost:8000/api/signup', json={'email':'debug@example.com','password':'debugpass'}, timeout=10)
    print('Status:', r.status_code)
    print('Body:', r.text)
except Exception as e:
    print('Request error:', e)
