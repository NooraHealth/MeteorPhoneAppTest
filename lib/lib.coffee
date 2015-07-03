
Meteor.getContentSrc = ()->
  #return "http://grass-roots-science.info/"
  if Meteor.isClient or Meteor.isCordova
    console.log "Geting the content src, : "
    console.log Session.get "content src"
    if Session.get "content src"
      return Session.get "content src"
    else
      return ""
  if Meteor.isServer
    return Meteor.call "contentEndpoint"

Meteor.filePrefix = (file)->
  #Store file into a directory by the user's username.
  if not file?
    return ""
  if file.type.match /// video/ ///
    prefix = CONTENT_FOLDER + VIDEO_FOLDER
  if file.type.match /// audio/ ///
    prefix = CONTENT_FOLDER + AUDIO_FOLDER
  if file.type.match /// image/ ///
    prefix = CONTENT_FOLDER + IMAGE_FOLDER

  return prefix + file.name
