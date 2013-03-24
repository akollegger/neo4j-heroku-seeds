var http = require('http');

/*
 * POST raw cypher request through to Neo4j
 */

exports.post = function(req, res) {
  console.log(req.body);
  postCypher(req.body,
    function(queryResult) {
        res.send(queryResult);
    }
  )
};

/*
 * Create a new user with Cypher
 */
exports.createUser = function(req, res) {
  console.log(req.body);
  postCypher(
    { 
      'query':'START ref=node(0) ' +
              'CREATE UNIQUE (ref)-[:USER]->(user {uid:{uidParam}, name:{nameParam}}) ' +
              'RETURN user',
      'params': {
        'uidParam': req.body.uid,
        'nameParam': req.body.name
      }
    },
    function(queryResult) {
        res.send(queryResult);
    }
  )
}

/*
 * List users
 */
exports.listUsers = function(req, res) {
  postCypher(
    { 
      'query':'START ref=node(0) MATCH (ref)-[:USER]->(users) RETURN users.uid, users.name',
      'params': {}
    },
    function(queryResult) {
        res.send(queryResult);
    }
  )
}

/*
 * Make a new friend for a user
 */
exports.befriendUsers = function(req, res) {
  postCypher(
    { 
      'query':'START ref=node(0) ' +
              'MATCH (ref)-[:USER]->(from), (ref)-[:USER]->(to) ' +
              'WHERE from.uid! = {fromParam} AND to.uid! = {toParam} ' +
              'CREATE UNIQUE (from)-[r:FRIEND]->(to) ' +
              'RETURN from.uid, type(r), to.uid',
      'params': {
        'fromParam': req.params.name,
        'toParam': req.body.to
      }
    },
    function(queryResult) {
        res.send(queryResult);
    }
  )
}

/*
 * List a user's friends
 */
exports.listFriends = function(req, res) {
  postCypher(
    { 
      'query':'START ref=node(0) ' +
              'MATCH (ref)-[:USER]->(user)-[:FRIEND]-(friends) ' +
              'WHERE user.uid! = {userParam} ' +
              'RETURN friends.uid, friends.name',
      'params': {
        'userParam': req.params.name
      }
    },
    function(queryResult) {
        res.send(queryResult);
    }
  )
}

function postCypher(cypher, callback) {

  var cypherString = JSON.stringify(cypher);

  var headers = {
    'Content-Type': 'application/json',
    'Content-Length': cypherString.length
  };

  var neo4jOptions = {
    host: 'localhost',
    port: 7474,
    path: '/db/data/cypher',
    method: 'POST',
    headers: headers
  };

  // Setup the request.  The options parameter is
  // the object we defined above.
  var neo4jReq = http.request(neo4jOptions, function(neo4jRes) {
    neo4jRes.setEncoding('utf-8');

    var neo4jResponseString = '';

    neo4jRes.on('data', function(data) {
      neo4jResponseString += data;
    });

    neo4jRes.on('end', function() {
      callback(neo4jResponseString);
    })
  });

  neo4jReq.on('error', function(err) {
    console.log(err);
  });

  neo4jReq.write(cypherString);
  neo4jReq.end();
};


