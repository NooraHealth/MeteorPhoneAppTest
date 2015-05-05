Template.uploadForm.events {
  "click button[name=upload]":(event, template) ->
    console.log "cLICKES "
    event.preventDefault()
    type = "type"
    console.log event.target
    if $(event.target).hasClass "video"
      type = "video"
    else if $(event.target).hasClass "image"
      type= "image"
    else if $(event.target).hasClass "audio"
      type = "audio"

    file =  $("input.file")[0].files[0]
    console.log "FILE: ", file

    uploader = new Slingshot.Upload "s3"

    uploader.send file , (err, downloadURL) ->
      if err
        console.log "Error uploading file: ", err
      else
        console.log downloadURL

    #Meteor.call "uploadContent", file, type, (error)->
      #if error
        #console.log error
  }

Template.uploadForm.helpers {
  files: ()->
      return S3.collection.find()
  }
  
