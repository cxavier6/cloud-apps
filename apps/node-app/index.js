const express = require('express');
const Redis = require('ioredis');
const app = express();
const port = 3000;

const redis_host = process.env.REDIS_HOST;

// Connect to Redis
const redis = new Redis({
  host: redis_host, 
  port: 6379
});

redis.on('error', (err) => {
  console.log('Redis error: ', err);
});

redis.on('connect', () => {
  console.log('Connected to Redis');
});

// Text route with caching
app.get('/text', (req, res) => {
  redis.get('text', (err, data) => {
    if (err) {
      console.log('Cache error:', err);
      res.status(500).send('Cache error');
      return;
    }

    if (data) {
      console.log('Cache found for /text:', data);
      res.send(`${data} (CACHED)`);
    } else {
      const text = 'Hello world';
      console.log('No cache for /text. Sending fresh response:', text);

      // Store in cache for 10 seconds
      redis.setex('text', 10, text);

      res.send(text);
    }
  });
});

// Time route with caching
app.get('/time', (req, res) => {
  redis.get('time', (err, data) => {
    if (err) {
      console.log('Cache error:', err);
      res.status(500).send('Cache error');
      return;
    }

    if (data) {
      console.log('Cache found for /time:', data);
      res.send(`${data} (CACHED)`);
    } else {
      const time = new Date().toISOString();
      console.log('No cache for /time. Sending fresh response:', time);

      // Store in cache for 10 seconds
      redis.setex('time', 10, time);

      res.send(time);
    }
  });
});

// Initialize server
app.listen(port, '0.0.0.0', () => {
  console.log(`Node app running on ${port}`);
});
