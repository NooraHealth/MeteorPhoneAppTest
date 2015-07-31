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
      deferred = Q.defer()

      @.getLocalServerUrl()
      .then ( url ) =>
        if url and url.length > 0
          deferred.resolve url
        else
          deferred.resolve false
      .fail ( err ) =>
        deferred.reject err

      return deferred.promise

    startLocalServer: ()=>
      deferred = Q.defer()

      if @.httpd
        @.checkIfServerIsUp()
        .then ( url ) =>
          if url
            deferred.resolve url
          else
            ContentDownloader.getLocalFilesSystem(0)
            .then (fs)=>
              path = fs.root.nativeURL.replace "file://", ""
              @.startServerAtRoot( path )
            .then ( url )=>
              deferred.resolve url
        .fail (err)=>
          deferred.reject err
      else
        deferred.reject "Httpd not availble/ready"

      return deferred.promise

    startServerAtRoot: ( wwwroot )=>
      deferred = Q.defer()
      @.wwwroot = wwwroot

      @.httpd.startServer {
        'wwwroot': wwwroot
        'port':8080
        'localhost_only':true
      }, (url)=>
        @.url = url
        deferred.resolve url
      , (err)=>
        deferred.reject err

      return deferred.promise

