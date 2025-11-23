from fastapi import FastAPI
from pydantic import BaseModel
import redis, pickle, os
MODEL_PATH = '/app/models/model.pkl'
if not os.path.exists(MODEL_PATH):
    print('warning: model missing at', MODEL_PATH)
r = redis.Redis(host=os.getenv('REDIS_HOST','redis-master.unified.svc.cluster.local'), port=int(os.getenv('REDIS_PORT','6379')), db=0)
app = FastAPI()
class Req(BaseModel):
    user_id: str
@app.post('/score')
def score(req: Req):
    key = f'user:{req.user_id}'
    if not r.exists(key):
        return {'user_id': req.user_id, 'score': None, 'message': 'no features'}
    d = {k.decode(): v.decode() for k,v in r.hgetall(key).items()}
    events = float(d.get('events_total',0))
    purchases = float(d.get('events_purchase',0))
    revenue = float(d.get('revenue_total',0))
    X = [[events, purchases, revenue]]
    if 'model' not in globals():
        global model
        with open(MODEL_PATH,'rb') as f:
            model = pickle.load(f)
    score = float(model.predict_proba(X)[0][1])
    return {'user_id': req.user_id, 'score': score}
