
class @CordovaClient extends Base
  
  #in a new cordova client, first initialize the server
  constructor: ()->
    super()
    console.log "Cordova client is initializing"
    @.localServer = LocalServer.get()
    #@.localServer.startLocalServer()
    #.then (url)=>
      #console.log url
      #@.contentSrc = url
    #.fail (err)=>
      #console.log "CordovaClient: Error starting the local server" + err

    #Check the server intermittently to make sure it's up
    Meteor.setInterval initializeServer, 5000

  whereAreTheLocalFiles: ()->
    return @.localServer.getWwwRoot()
  
  getContentSrc: ()=>
    return "http://127.0.0.1:8080/"
    #return @.contentSrc

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
    console.log @.tag+ "DEBUG"+ "Cordova Client is about to restart your server"
    return @.localServer.startLocalServer()
    
