
exec = require('child_process').exec

startServer = (params) ->
  app = params.app

  app.post '/plugin/cypher', (req, res) ->
    exec 'date', (error, stdout, stderr) ->
      res.send {stdout, stderr, req:req.body}

module.exports = {startServer}