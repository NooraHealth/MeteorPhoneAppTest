Meteor.startup ()->
  if Meteor.isCordova
    Meteor.subscribe "users"
    Meteor.subscribe "all_curriculums"
    Meteor.subscribe "all_modules"
    Meteor.subscribe "all_lessons"
    initializeServer()
    Meteor.NooraClient = new CordovaClient()
  else
    Meteor.NooraClient = new BrowserClient()
