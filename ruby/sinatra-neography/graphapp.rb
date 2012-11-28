require 'sinatra'
require 'neography'
require 'net/http'
require 'uri'
require 'json'

neo4j_uri = URI(ENV['NEO4J_URL'] || "http://localhost:7474")
neo = Neography::Rest.new(neo4j_uri.to_s) # Neography expects a string

def check_for_neo4j(neo4j_uri)
  begin
    response = Net::HTTP.get_response(neo4j_uri)
    if (response.code != "200")
      abort "Sad face. Neo4j does not appear to be running. #{neo4j_uri} responded with code: #{response.code}"
    end
  rescue
    abort "Sad face. Neo4j does not appear to be running at #{neo4j_uri}" 
  end
  puts "Awesome! Neo4j is available at #{neo4j_uri}"
end

def create_graph(neo)
  # use the imperative API to create a simple graph: (Neo4j)-[:loves]->(you)
  # Graphs store data in nodes and relationships, with properties on both. 
  # By convention, text representations of a graph use parenthesis to indicate 
  # a node and square brackets to indicate a relationship.

  # 1. get the 'from' node, which we expect to be named "Neo4j"
  from = neo.get_root # we'll use the root node as the 'from'

  # 2. get the properties of the 'from' node
  pr = neo.get_node_properties(from)

  # 3. if a 'name' property exists, assume we've already created the graph
  return if pr && pr['name']

  # 4. otherwise, set the 'name' property
  neo.set_node_properties(from, {"name" => "Neo4j"})

  # 5. create the 'to' node
  to = neo.create_node("name" => "you")

  # 6. create a 'loves' relationship from the 'from' node to the 'to' node
  neo.create_relationship("loves", from, to)

  # To learn more, read the excellent Neo4j Manual at http://docs.neo4j.org
end

check_for_neo4j(neo4j_uri)

create_graph(neo)

get '/' do
  # Cypher is a graph query language that uses pattern matching.
  cypher_query = "START n=node(*) " + # start by considering all nodes in the graph
    "MATCH (n)-[r:loves]->(m) " +     # pattern match any node 'n' with an outgoing 'loves' relationship 'r' to some other node 'm'
    "return n, r, m"                  # return both nodes, and the relationship between them

  results = neo.execute_query(cypher_query) # execute the query, capture results
  
  row = results['data'].first # we just want the first row of the result data

  # Output the name property of the 'm' node, the relationship type of 'r' and the name property of the 'm' node.
  "<h1>#{row[0]['data']['name']} #{row[1]['type']} #{row[2]['data']['name']}</h1>
   <hr/>
   <h2>Cypher query</h2>
   <p>Considering all nodes, find the pattern where some 'n' node has a 'loves' relationship to some 'm' node...</p>
   <pre>#{cypher_query}</pre>
   <h2>Result</h2>
   <p>In the result row, node 'n' is at row[0], relationship 'r' at row[1] and node 'm' at row[2].
      Look for the 'self' properties, which indicate the identity URL of each entity. 
   </p>
   <p>Raw JSON result row...</p>
   <pre>#{JSON.pretty_generate(row)}</pre>
  "
end
