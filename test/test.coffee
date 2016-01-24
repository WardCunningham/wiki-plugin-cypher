# build time tests for cypher plugin
# see http://mochajs.org/

cypher = require '../client/cypher'
expect = require 'expect.js'

describe 'cypher plugin', ->

  describe 'expand', ->

    # it 'can make itallic', ->
    #   result = cypher.expand 'hello *world*'
    #   expect(result).to.be 'hello <i>world</i>'
