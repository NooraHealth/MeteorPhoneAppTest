Meteor.startup ()->

  if Meteor.isCordova
    Session.set( "content src", 'http://127.0.0.1:8080/')
    Meteor.subscribe "users"
    Meteor.subscribe "all_curriculums"
    Meteor.subscribe "all_modules"
    Meteor.subscribe "all_lessons"
    this.initializeServer()
  else
    Meteor.call "contentEndpoint", (err, src)->
      Session.set "content src", src
