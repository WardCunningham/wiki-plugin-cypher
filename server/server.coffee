
exec = require('child_process').exec

startServer = (params) ->
  app = params.app

  curl = '
    curl -s -H "Accept: application/json; charset=UTF-8" -H "Content-Type: application/json" -H "Authorization: Basic bmVvNGo6TGV3UmVsaWM=" -X POST http://localhost:7474/db/data/cypher -d \'{                                                      
      "query" : "match (a)-->(b) return a.title, b.title limit 10",
      "params" : {"foo": "bar"}
    }\'
  '

  app.post '/plugin/cypher', (req, res) ->
    exec curl, (error, stdout, stderr) ->
      res.send {stdout, stderr, req:req.body}

module.exports = {startServer}