####
# Set up the local file server, serving files from
# the file:// storage on the phone for use in the app
####

#if Meteor.isClient
  #if Meteor.isCordova
    #httpd = null
    #httpUrl = null

##Start the local server at wwwroot
    #startServer = (wwwroot)->
      #console.log "Starting local mobile server at " ,  wwwroot
      #if httpd
        
        #console.log "This is httpd: "
        #console.log httpd
        ##check that the server is not already up
        #cordova.plugins.CorHttpd.getUrl (url)->
          #if url.length > 0
            #httpUrl = url
            #console.log "Server running at ", url
          #else
            #httpd.startServer {
            #'www_root': wwwroot
              #'port': 8080
              #'localhost_only':true
            #}, (url)->
              #httpUrl = url
              #console.log "Local server started at ", httpUrl
            #, (err)->
              #console.log "Failed to start server: ", err
      #else
        #console.log "CORhttp not available/ready"

## On startup, get the server wwwroot and start the server
    #Meteor.startup ()->
      #console.log "Cordova startup about to request file syste"
      #console.log cordova.plugins
      #httpd = if cordova && cordova.plugins && cordova.plugins.CorHttpd then cordova.plugins.CorHttpd else null
      #if httpd
        #window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs) ->
          #path = fs.root.toURL().replace "file://", ""
          #startServer path


