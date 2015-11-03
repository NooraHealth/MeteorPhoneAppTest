
Meteor.getContentSrc = ()->
  if Meteor.isCordova
    return 'http://127.0.0.1:8080/'
  return Meteor.settings.public.CONTENT_SRC
    
