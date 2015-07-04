Meteor.startup ()->

  Meteor.subscribe "users"
  Meteor.subscribe "all_curriculums"
  Meteor.subscribe "all_modules"
  Meteor.subscribe "all_lessons"
  if Meteor.isCordova
    console.log "Creating a new cordova client"
    Meteor.Client = new CordovaClient()
  else
    #Meteor.Client = BrowserClient

