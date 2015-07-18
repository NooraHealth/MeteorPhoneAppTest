Meteor.startup ()->
  if Meteor.isCordova
    console.log "In the meteor startup and about to initialize the server"
    Meteor.subscribe "users"
    Meteor.subscribe "all_curriculums"
    Meteor.subscribe "all_modules"
    Meteor.subscribe "all_lessons"
    initializeServer()
    Meteor.NooraClient = new CordovaClient()
  else
    Meteor.NooraClient = new BrowserClient()
