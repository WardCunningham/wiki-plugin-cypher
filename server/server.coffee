
# http://neo4j.com/developer/javascript/
# http://neo4j.com/docs/stable/rest-api-transactional.html#rest-api-execute-multiple-statements

request = require 'request'
uri = 'http://localhost:7474/db/data/transaction/commit'
headers = {Authorization: 'Basic bmVvNGo6TGV3UmVsaWM='}

cypher = (statement, parameters, done) ->
  statements = [{statement, parameters}]
  options = {uri, headers, json: {statements}}
  request.post options, (err, res) ->
    done err, res.body

statement = "
  match
    (site:Site)-[h:HAS]->
    (page:Page)-[l:LINK]->
    (link:Title)<-[i:IS]-(p:Page)
    where p.title in {slugs}
    with site,page,link
  match
    (page)-[:KNOWS]->(here:Site)
    where here.title in {sites}
    return page.title,site.title,link.title
"

startServer = (params) ->
  params.app.post '/plugin/cypher', (req, res) ->
    console.log JSON.stringify(req.body)
    cypher statement, req.body, (err, body) ->
      res.send
        results: body.results || []
        stdout: JSON.stringify(body)
        stderr: JSON.stringify({http: err, neo4j: body.errors})

module.exports = {startServer}
