Meteor.startup ()->

  console.log "Subscribing to all"
  Meteor.subscribe "users"
  Meteor.subscribe "all_curriculums"
  Meteor.subscribe "all_modules"
  Meteor.subscribe "all_lessons"

  console.log "This is the meteor client: "
  console.log Meteor.Client
  httpd = if cordova and cordova.plugins and cordova.plugins.CorHttpd then cordova.plugins.CorHttpd else null
  console.log "This is the httpd in the startup: "
  console.log httpd
  if Meteor.isCordova
    Meteor.Client = new CordovaClient(httpd)
  else
    #Meteor.Client = BrowserClient

