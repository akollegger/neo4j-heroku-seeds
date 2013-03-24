Neo4j Heroku Seed - Express.js Proxy
====================================

## How this was made

Assuming: `node@0.8.14`, `npm@1.1.65`, `foreman@0.60.0`, `express@3.0.5`

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
   3. Try it out locally: 
      - `npm install`
      - `foreman start`
   4. Deploy to Heroku:
      - `sh ../../bin/detachme.sh`
      - `heroku create`
      - `heroku open`
4. Remove all the placeholder `user` stuff from `app.js`, snip:
```
  , user = require('./routes/user')
```

```
app.get('/users', user.list);
```
5. Remove user.js route: `rm routes/user.js`
6. Simplify by moving the routes/index.js function inline in app.js
7. Add endpoint for posting Neo4j queries:

