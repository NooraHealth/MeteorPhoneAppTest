
Meteor.getContentSrc = ()->
  console.log "Getting the content src in the Meteor.getContetn "
  if Meteor.isClient or Meteor.isCordova
    if Session.get "content src"
      return Session.get "content src"
    else
      return ""
  if Meteor.isServer
    return Meteor.call "contentEndpoint"
