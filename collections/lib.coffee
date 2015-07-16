
Meteor.getContentSrc = ()->
  #return "http://grass-roots-science.info/"
  if Meteor.isCordova
    console.log "Returning the content src for the cordova"
    return 'http://127.0.0.1:8080/'
  else
    return "http://noorahealthcontent.s3-us-west-1.amazonaws.com/"
    
