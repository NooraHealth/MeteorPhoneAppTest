
class @CordovaClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    console.log "Cordova client is initializing"
    @.localServer = LocalServer.get()
    @.localServer.startLocalServer()
    .then (url)=>
      @.contentSrc = url
    .fail (err)=>
      console.log "CordovaClient: Error starting the local server" + err
  
  getContentSrc: ()=>
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
    console.log @.tag+ "DEBUG"+ "This is the local server"
    return @.localServer.startLocalServer()
    
