#!/usr/bin/env python3
import json, random, time
from datetime import datetime
from kafka import KafkaProducer
TOPIC = "events"
producer = KafkaProducer(bootstrap_servers=["kafka:9092"],
                         value_serializer=lambda v: json.dumps(v).encode('utf-8'))
users = [f"user_{i}" for i in range(1,1001)]
items = [f"item_{i}" for i in range(1,501)]
pages = ["home","product","checkout","search","profile"]
def gen_event():
    return {
        "event_id": f"ev_{int(time.time()*1000)}_{random.randint(1,9999)}",
        "user_id": random.choice(users),
        "session_id": f"sess_{random.randint(1,10000)}",
        "page": random.choice(pages),
        "item": random.choice(items),
        "price": round(random.uniform(5,500),2),
        "timestamp": datetime.utcnow().isoformat() + 'Z',
        "event_type": random.choices(["click","view","purchase","login"], weights=[0.5,0.3,0.05,0.15])[0]
    }
if __name__ == '__main__':
    print('Producing events to kafka...')
    while True:
        ev = gen_event()
        producer.send(TOPIC, ev)
        if random.random() < 0.01:
            producer.flush()
        time.sleep(0.02)
