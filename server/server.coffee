
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

startServer = (params) ->
  params.app.post '/plugin/cypher', (req, res) ->
    query = 'match (a)-->(b) return a.title, b.title limit 10'
    params = {"foo": "bar"}
    cypher query, params, (err, body) ->
      res.send
        stdout: JSON.stringify(body)
        stderr: JSON.stringify(err)
        req: req.body

module.exports = {startServer}