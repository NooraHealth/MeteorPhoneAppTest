Meteor.methods {
  uploadContent: (file, type)->
    s3 = new AWS.S3()
    console.log file
    console.log typeof file
    console.log "TYEP: ", type

    folder = CONTENT_FOLDER
    if type== "video"
      prefix = folder + VIDEO_FOLDER
    else if type== "image"
      prefix = folder+ IMAGE_FOLDER
    else if type == "audio"
      prefix = folder + AUDIO_FOLDER
    else
      console.log "sending error"
      Meteor.Error "invalid parameter", "Invalid file type"

    s3.upload {Bucket: BUCKET, ContentType: file.type,  Key: prefix + file.name, Body: JSON.stringify(file, null, '')}, (err, data) ->
      console.log "upload CALLBACK"
      console.log err
      console.log data
    

  refreshContent: ()->
    Curriculum.remove({})
    Lessons.remove({})
    Modules.remove({})

    Curriculum.insert curriculum for curriculum in CURRICULUM
    Lessons.insert lesson for lesson in LESSONS
    Modules.insert module for module in MODULES
}
