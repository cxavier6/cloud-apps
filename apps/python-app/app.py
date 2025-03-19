from fastapi import FastAPI
from datetime import datetime
import redis
import os

app = FastAPI()

redis_host = os.getenv("REDIS_HOST")
cache = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.get("/text")
def get_text():
    cached_text = cache.get("text-cache")

    if cached_text:
        return {"text (CACHE)": cached_text}

    text = "Hello World!"
    cache.setex("text-cache", 60, text)  
    return {"text": text}

@app.get("/time")
def get_time():
    cached_time = cache.get("time-cache")

    if cached_time:
        return {"server_time (CACHE)": cached_time}

    current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    cache.setex("time-cache", 60, current_time) 
    return {"server_time": current_time}
