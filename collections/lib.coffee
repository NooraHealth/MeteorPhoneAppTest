
Meteor.getContentSrc = ()->
  if Meteor.isCordova
    return 'http://127.0.0.1:8080/'
  if not Meteor.settings.public.CONTENT_SRC
    return "http://noorahealthcontent.noorahealth.org/"
  else
    return Meteor.settings.public.CONTENT_SRC
    
