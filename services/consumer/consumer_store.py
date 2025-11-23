#!/usr/bin/env python3
import json, time
from kafka import KafkaConsumer
import redis, os
KAFKA_BROKER = os.getenv('KAFKA_BROKER','kafka:9092')
REDIS_HOST = os.getenv('REDIS_HOST','redis-master.unified.svc.cluster.local')
consumer = KafkaConsumer('events', bootstrap_servers=[KAFKA_BROKER],
                         value_deserializer=lambda m: json.loads(m.decode('utf-8')),
                         auto_offset_reset='earliest', enable_auto_commit=True, group_id='feature-store')
r = redis.Redis(host=REDIS_HOST, port=6379, db=0)
def update_user(ev):
    uid = ev['user_id']
    key = f'user:{uid}'
    pipe = r.pipeline()
    pipe.hincrby(key, 'events_total', 1)
    pipe.hincrby(key, f"events_{ev['event_type']}", 1)
    pipe.hset(key, 'last_seen', ev['timestamp'])
    if ev['event_type']=='purchase':
        pipe.hincrbyfloat(key, 'revenue_total', float(ev['price']))
    pipe.expire(key, 7*24*3600)
    pipe.execute()
if __name__ == '__main__':
    print('Consuming events...')
    for msg in consumer:
        update_user(msg.value)
