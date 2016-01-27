askForToken = ()->
    window.parent.postMessage { action: 'getToken' }, '*'

module.exports =
    get: (path, attributes, callback)->
        playRequest 'GET', path, attributes, (error, body, response) ->
            callback error, body, response

    post: (path, attributes, callback) ->
        playRequest 'POST', path, attributes, (error, body, response) ->
            callback error, body, response

    put: (path, attributes, callback) ->
        console.log 'put'
        playRequest 'PUT', path, attributes, (error, body, response) ->
            callback error, body, response   

    del: (path, attributes, callback) ->
        playRequest 'DELETE', path, attributes, (error, body, response) ->
            callback error, body, response

playRequest = (method, path, attributes, callback) ->
    askForToken()
    xhr = new XMLHttpRequest
    xhr.open method, "/ds-api/#{path}", true

    eventListening = (event) ->
        window.removeEventListener 'message', eventListening
        auth = event.data
        xhr.onload = ->
            return callback null, xhr.response, xhr

        xhr.onerror = (e) ->
            err = 'Request failed : #{e.target.status}'
            return callback err

        xhr.setRequestHeader 'Content-Type', 'application/json'
        xhr.setRequestHeader 'Authorization', 'Basic ' + btoa(auth.appName + ':' + auth.token)
       
        if attributes?
            xhr.send JSON.stringify(attributes)
        else
            xhr.send()
        return

    window.addEventListener 'message', eventListening, false