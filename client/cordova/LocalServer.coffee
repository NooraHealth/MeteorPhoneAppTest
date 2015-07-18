####
# Thank you to Nate Strauser for his example meteor-offline-files-demo
#####

class @LocalServer
  instance = null
  @get: ()->
    instance ?= new Instance()
    return instance

  class Instance extends Base
    constructor: ()->
      super()
      @.tag = "LocalServer"
      @.httpd = @.getHttpd()
      @.url = null
      @.wwwroot= ""

    getHttpd: ()=>
      return if cordova && cordova.plugins && cordova.plugins.CorHttpd then cordova.plugins.CorHttpd else null

    getWwwRoot: ()=>
      return @.wwwroot

    getLocalServerUrl: ()=>
      deferred = Q.defer()

      if !@.httpd
        deferred.reject "Cordova httpd not ready/available"
      if @.url
        deferred.resolve @.url
      else
        @.httpd.getURL((url)=>
          @.url = url
          deferred.resolve url
        )

      return deferred.promise

    checkIfServerIsUp: ()=>
      console.log @.tag + "LOG: " + "checking if the server is up"
      deferred = Q.defer()

      @.getLocalServerUrl()
      .then ( url ) =>
        if url and url.length > 0
          console.log @.tag + "LOG: "+ "Server is already up at " + url
          deferred.resolve url
        else
          deferred.resolve false
      .fail ( err ) =>
        deferred.reject err

      return deferred.promise

    startLocalServer: ()=>
      console.log @.tag +  "LOG"+ "Starting the local server"
      deferred = Q.defer()

      if @.httpd
        @.checkIfServerIsUp()
        .then ( url ) =>
          if url
            console.log @.tag+ "DEBUG"+ "Server was already up"+ url
            deferred.resolve url
          else
            ContentDownloader.getLocalFilesSystem(0)
            .then (fs)=>
              console.log @.tag+ "DEBUG"+ "Got the filesystem"+ fs
              path = fs.root.nativeURL.replace "file://", ""
              @.startServerAtRoot( path )
            .then ( url )=>
              console.log @.tag+ "DEBUG"+ "Got the server url"+ url
              deferred.resolve url
        .fail (err)=>
          deferred.reject err
      else
        deferred.reject "Httpd not availble/ready"

      return deferred.promise

    startServerAtRoot: ( wwwroot )=>
      console.log @.tag+ "LOG"+ "Starting the server at the root" +  wwwroot
      deferred = Q.defer()
      @.wwwroot = wwwroot

      @.httpd.startServer {
        'wwwroot': wwwroot
        'port':8080
        'localhost_only':true
      }, (url)=>
        @.url = url
        console.log @.tag+ "LOG"+ "Server started at "+ wwwroot
        deferred.resolve url
      , (err)=>
        console.log @.tag+ "ERROR"+ "Failed to start server: " + err
        deferred.reject err

      return deferred.promise

