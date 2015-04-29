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
  #infoLabel: ()->
    #console.log "Infolabel"
    #instance = Template.instance()
    #info = instance.info.get()
    #if !info
      #return

    #progress = instance.globalInfo.get()
    #if progress.running
      #return info.name + ' - ' + progress.progress + '% - [' + progress.bitrate + ']'
    #else
      #return info.name + ' - ' + info.size + 'B'

  #progress: ()->
    #return Template.instance().globalInfo.get().progress + "%"
#}
#Template.uploadForm.events {
  #"click .start": (e)->
    #Uploader.startUpload.call Template.instance(), e
#}

#Template.uploadForm.onRendered ()->
  #Uploader.render.call @

#Template.uploadForm.onCreated ()->
  #Uploader.init @
  
