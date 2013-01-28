Neo4j Heroku Seed - Express.js Proxy
====================================

## How this was made

Assuming: `node`, `npm`, `foreman`, `express`

Here's the play-by-play for creating this seed:

1. Generate a standard express application
   - `express express-proxy`
   - `cd express-proxy`
2. Add this readme file
3. Prepare the Express app for deployment to Heroku
   1. Add explicit node and npm version to `package.json`
```
"engines": {
  "node": "0.8.x",
  "npm": "1.1.x"
},
```
   2. Create a Profile, containing
```
web: node app
```
   3. Try it out: 
      - `npm install`
      - `foreman start`
