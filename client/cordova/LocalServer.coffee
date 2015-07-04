####
# Thank you to Nate Strauser for his example meteor-offline-files-demo
#####

class @LocalServer
  self = @

  constructor: (@httpd)=>
    #@.httpd = @.getHttpd()
    console.log "httpd"
    console.log @.httpd
    self = @
    @.url = null
    console.log self

  getHttpd: ()=>
    return if cordova && cordova.plugins && cordova.plugins.CorHttpd then cordova.plugins.CorHttpd else null

  getLocalServerUrl: ()=>
    deferred = Q.defer()

    if !self.httpd
      deferred.reject "Cordova httpd not ready/available"
    if self.url
      deferred.resolve self.url
    else
      self.httpd.getURL((url)=>
        self.url = url
        deferred.resolve url
      )

    return deferred.promise

  checkIfServerIsUp: ()=>
    deferred = Q.defer()
    console.log "in checkIftheServerISUp"

    self.getLocalServerUrl()
    .then ( url ) =>
      console.log "Got the local server url"
      console.log url
      if url and url.length > 0
        console.log "Got the local serverURL"
        deferred.resolve url
      else
        deferred.resolve false
    .fail ( err ) =>
      deferred.reject err

    return deferred.promise

  startLocalServer: ()=>
    console.log "About to start the server"
    console.log self.httpd?
    deferred = Q.defer()

    if self.httpd
      console.log "There was a self.httpd"
      self.checkIfServerIsUp()
      .then ( url ) =>
        if url
          deferred.resolve url
        else
          LocalContent.getLocalFilesSystem 0,  (fs)=>
            path = fs.root.nativeURL.replace "file://", ""
            self.startServerAtRoot( path )
              .then ( url )=>
                console.log "Got the url!! "
                console.log url
                deferred.resolve url
              .fail ( error ) =>
                deferred.reject error
      .fail (err)=>
        deferred.reject err
    else
      deferred.reject "Httpd not availble/ready"
    return deferred.promise

  startServerAtRoot: ( wwwroot )=>
    deferred = Q.defer()

    self.httpd.startServer {
      'wwwroot': wwwroot
      'port':8080
      'localhost_only':true
    }, (url)=>
      self.url = url
      console.log "Server started at root: ", url
      deferred.resolve url
    , (err)=>
      console.log "Failed to start server: " + err
      console.log err
      deferred.reject err

    return deferred.promise

