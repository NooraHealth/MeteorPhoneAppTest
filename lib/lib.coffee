this.getMediaUrl =() ->
  console.log "Getting the media URL"
  Meteor.call 'isProduction', (err, isProduction) ->
    if err
      console.log("Error determining production env")

    else
      if isProduction
        console.log("Returning MEDIA_URL for production env")
        return "https://noorahealthcontent.s3-us-west-1.amazonaws.com/"
     
      else
        console.log("Returning MEDIA_URL for dev env")
        return 'https://noorahealth-development.s3-west-1.amazonaws.com/'

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
