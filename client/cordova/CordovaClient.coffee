
class @CordovaClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    @.localServer = LocalServer.get()
    @.localServer.startLocalServer()
    .then (url)=>
      @.contentSrc = url
    .fail (err)=>
      console.log "CordovaClient: Error starting the local server" + err
  
  contentSrc: ()=>
    return @.contentSrc

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
    
