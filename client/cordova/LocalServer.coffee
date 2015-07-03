####
# Thank you to Nate Strauser for his example meteor-offline-files-demo
#####

class @LocalServer
  self = @
  constructor: ()->
    @.httpd = @.getHttpd()
    @.url = null
    console.log "@.httpd: "
    console.log @.httpd

  getHttpd: ()->
    return if cordova && cordova.plugins && cordova.plugins.CorHttpd then cordova.plugins.CorHttpd else null

  getLocalServerUrl: ()->
    deferred = Q.defer()

    if !self.httpd
      deferred.reject "Cordova httpd not ready/available"
    if self.url
      deferred.resolve self.url
    else
      self.httpd.getURL((url)->
        self.url = url
        deferred.resolve url
      )

    return deferred.promise

  checkIfServerIsUp: ()->
    deferred = Q.defer()

    url = @.getLocalServerUrl()
      .then (url) ->
        if url and url.length > 0
          deferred.resolve true
        else
          deferred.resolve false
      .fail (err) ->
        deferred.reject err

    return deferred.promise

  startLocalServer: ()->
    deferred = Q.defer()
    self = @

    if self.httpd
      LocalContent.getLocalFilesSystem 0,  (fs)->
        path = fs.root.nativeURL.replace "file://", ""
        console.log "Root for server will be at: ", path
        self.startServerAtRoot( path )
          .then (started)->
            deferred.resolve started
          .fail ( error ) ->
            deferred.reject error

    return deferred.promise

  startServerAtRoot: ( wwwroot )->
    deferred = Q.defer()
    self = @

    if self.httpd
      self.checkIfServerIsUp()
        .then (serverIsUp) ->
          if serverIsUp
            deferred.resolve true
          else
            self.httpd.startServer {
              'wwwroot': wwwroot
              'port':8080
              'localhost_only':true
            }, (url)->
              self.url = url
              console.log "Server started at root: ", url
              deferred.resolve true
            , (err)->
              console.log "Failed to start server: " + err
              deferred.reject err
    else
      deferred.reject "CorHttpd plugin is not available/ready"

    return deferred.promise
