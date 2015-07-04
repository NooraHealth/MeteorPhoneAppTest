
class @CordovaClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    console.log "Cordova"
    console.log @
    @.tag = "CordovaClient"
    @log @.tag, "DEBUG", "construction of the cordova client"
    @.localServer = LocalServer.get()
    @.localServer.startLocalServer()
    .then (url)=>
      @.contentEndpoint = url
      Session.set( "content src",url)
    .fail (err)=>
      console.log "CordovaClient: Error starting the local server" + err
  
  contentEndpoint: ()=>
    return @.contentEndpoint

  getContentEndpoint: ()=>
    deferred = Q.defer()

    @.localServer.getLocalServerUrl()
    .then (url)=>
      deferred.resolve url
    .fail (err)=>
      deferred.reject err

    return deferred.promise

  checkIfServerIsUp: ()=>
    return @.localServer.checkIfServerIsUp()

  restartLocalServer: ()=>
    @log @.tag, "DEBUG", "This is the local server"
    return @.localServer.startLocalServer()
    
