from pymongo import MongoClient
from pymongo.database import Database
from pymongo.collection import Collection
from pymongo.results import InsertOneResult
from typing import Optional, Any, Dict
import os

# load .env
from dotenv import load_dotenv
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '.env'))

MONGO_URL = os.environ.get('MONGO_URL')
DB_NAME = os.environ.get('DB_NAME', 'cineviax')

print('Using MONGO_URL:', MONGO_URL)

try:
    client: MongoClient[Any] = MongoClient(MONGO_URL, serverSelectionTimeoutMS=5000)
    # trigger server selection
    info = client.server_info()
    print('Connected to MongoDB server version:', info.get('version'))
    db: Database[Any] = client[DB_NAME]
    # test read/write
    test_col: Collection[Any] = db['__test_connection']
    doc: Dict[str, Any] = {'test': 'ok'}
    res: InsertOneResult = test_col.insert_one(doc)
    print('Inserted test doc id:', res.inserted_id)
    found: Optional[Dict[str, Any]] = test_col.find_one({'_id': res.inserted_id})
    print('Found doc:', found)
    test_col.delete_one({'_id': res.inserted_id})
    print('Cleanup done')
except Exception as e:
    print('ERROR connecting to MongoDB:', repr(e))
    raise
