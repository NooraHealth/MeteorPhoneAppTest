
Meteor.getContentSrc = ()->
  #return "http://grass-roots-science.info/"
  if Meteor.isCordova
    console.log "Returning the content src for the cordova"
    return 'http://127.0.0.1:8080/'
  else
    console.log "Returning content src"
    return "http://noorahealthcontent.noorahealth.org/"
