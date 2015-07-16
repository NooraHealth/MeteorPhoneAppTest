
Meteor.getContentSrc = ()->
  #return "http://grass-roots-science.info/"
  if Meteor.isCordova
    console.log "Returning the content src for the cordova"
    return 'http://127.0.0.1:8080/'
  if Meteor.isClient
    if Session.get "content src"
      return Session.get "content src"
    else
      return ""
  if Meteor.isServer
    return Meteor.call "contentEndpoint"
