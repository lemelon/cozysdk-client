client = require './utils/client'

# utility functions
checkError = (error, response, body, code, callback) ->
    callback errorMaker error, response, body, code

errorMaker = (error, response, body, expectedCode) ->
    if error
        return error
    else if response.status isnt expectedCode
        msgStatus = "expected: #{expectedCode}, got: #{response.statusCode}"
        err = new Error "#{msgStatus} -- #{body.error} -- #{body.reason}"
        err.status = response.statusCode
        return err
    else
        return null

define = (docType, name, request, callback) ->
    {map, reduce} = request

    # transforms all functions in anonymous functions
    # function named(a, b){...} --> function (a, b){...}
    # function (a, b){...} --> function (a, b){...}
    if reduce? and typeof reduce is 'function'
        reduce = reduce.toString()
        reduceArgsAndBody = reduce.slice reduce.indexOf '('
        reduce = "function #{reduceArgsAndBody}"

    view =
        reduce: reduce
        map: """
            function (doc) {
              if (doc.docType.toLowerCase() === "#{docType.toLowerCase()}") {
                filter = #{map.toString()};
                filter(doc);
              }
            }
        """

    path = "request/#{docType}/#{name.toLowerCase()}/"
    client.put path, view, (error, body, response) ->
        checkError error, response, body, 200, callback

module.exports.create = (docType, attributes, callback) ->
    path = "data/"
    attributes.docType = docType
    if attributes.id?
        path += "#{attributes.id}/"
        delete attributes.id
        return callback new Error 'cant create an object with a set id'
    
    client.post path, attributes, (error, body, response) ->
        if error
            callback error
        else
            callback null, JSON.parse body

module.exports.find = (id, callback) ->
    client.get "data/#{id}/", null, (error, body, response) ->
        if error
            callback error
        else if response.status is 404
            callback null, null, null
        else
            callback null, body

module.exports.exists = (id, callback) ->
    client.get "data/exist/#{id}/", null, (error, body, response) ->
        if error
            callback error
        else if not body? or not body.exist?
            callback new Error "Data system returned invalid data."
        else
            callback null, body.exist

module.exports.updateAttributes = (docType, id, attributes, callback) ->
    console.log 'updateAttributes'
    attributes.docType = docType
    client.put "data/merge/#{id}/", attributes, (error, body, response) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 200
            callback new Error "Server error occured."
        else
            callback null, JSON.parse body

module.exports.destroy = (id, callback) ->
    client.del "data/#{id}/", null, (error, body, response) ->
        if error
            callback error
        else if response.status is 404
            callback new Error "Document #{id} not found"
        else if response.status isnt 204
            callback new Error "Server error occured."
        else
            callback null

module.exports.defineRequest = (docType, name, request, callback) ->
    if typeof(request) is "function" or typeof(request) is 'string'
        map = request
    else
        map = request.map
        reduce = request.reduce
    define docType, name, {map, reduce}, callback

module.exports.run = (docType, name, params, callback) ->
    [params, callback] = [{}, params] if typeof(params) is "function"

    path = "request/#{docType}/#{name.toLowerCase()}/"
    client.post path, params, (error, body, response) ->
        if error
            callback error
        else if response.status isnt 200
            callback new Error util.inspect body
        else
            callback null, body

module.exports.requestDestroy = (docType, name, params, callback) ->
    [params, callback] = [{}, params] if typeof(params) is "function"
    params.limit ?= 100

    path = "request/#{docType}/#{name.toLowerCase()}/destroy/"
    client.put path, params, (error, body, response) ->
        checkError error, response, body, 204, callback