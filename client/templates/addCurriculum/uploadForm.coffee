Template.uploadForm.events {
  "click button[name=upload]":(event, template) ->
    console.log "cLICKES "
    files= $("input.file")[0].files
    console.log "CLICKED:", files
    S3.upload {
      files: files,
      path: "/NooraHealth/",
    }, (e, r) ->
      if e
        alert "There was an error uploading your image, please try again"
      else
        console.log "File upload result: ", r

    return false
  }

Template.uploadForm.helpers {
  files: ()->
      return S3.collection.find()
  }
  
