
class @CordovaClient
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    console.log "Initializing the cordova client"
    self.localContent = new LocalContent()
    self.localServer = new LocalServer(httpd)
    self.localServer.startLocalServer()
    .then (url)=>
      self.contentEndpoint = url
      console.log "Setting the content endpoint: "
      console.log url
      Session.set( "content src",url)

    .fail (err)=>
      console.log "CordovaClient: Error starting the local server" + err
  
  contentEndpoint: ()=>
    console.log "CordovaClient: retrieving the content endpoint: "+self.contentEndpoint
    return self.contentEndpoint

  getContentEndpoint: ()=>
    deferred = Q.defer()

    self.localServer.getLocalServerUrl()
      .then (url)=>
        deferred.resolve url
      .fail (err)=>
        deferred.reject err

    return deferred.promise

  checkIfServerIsUp: ()=>
    return self.localServer.checkIfServerIsUp()

  restartLocalServer: ()=>
    console.log "Restarting the local server"
    
    return self.localServer.startLocalServer()
    
