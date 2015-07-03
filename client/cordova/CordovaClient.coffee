class @CordovaClient
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    console.log "Initializing the cordova client"
    @.localContent = new LocalContent()
    @.localServer = new LocalServer()
    @.localServer.startLocalServer()
      .then (started)->
        @.getContentEndpoint().then (url)-> @.contentEndpoint = url
      .fail (err)->
        console.log "CordovaClient: Error starting the local server" + err
  
  contentEndpoint: ()->
    console.log "CordovaClient: retrieving the content endpoint: "+@.contentEndpoint
    return @.contentEndpoint

  getContentEndpoint: ()->
    deferred = Q.defer()

    @.localServer.getLocalServerUrl()
      .then (url)->
        deferred.resolve url
      .fail (err)->
        deferred.reject err

    return deferred.promise

  checkIfServerIsUp: ()->
    return @.localServer.checkIfServerIsUp()

  restartLocalServer: ()->
    console.log "CordovaClient: restarting the local server"
    console.log "This is the local server: "+ @.localServer
    console.log @.localServer
    self = @

    self.localServer.checkIfServerIsUp()
      .then (serverIsUp) ->
        console.log "CordovaClient: is the server up: ", serverIsUp
        if !serverIsUp
          self.localServer.startLocalServer()

    return self

  

