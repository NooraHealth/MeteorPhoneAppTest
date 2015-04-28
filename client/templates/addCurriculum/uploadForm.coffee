Template.uploadForm.helpers {
  infoLabel: ()->
    console.log "Infolabel"
    instance = Template.instance()
    info = instance.info.get()
    if !info
      return

    progress = instance.globalInfo.get()
    if progress.running
      return info.name + ' - ' + progress.progress + '% - [' + progress.bitrate + ']'
    else
      return info.name + ' - ' + info.size + 'B'

  progress: ()->
    return Template.instance().globalInfo.get().progress + "%"
}
Template.uploadForm.events {
  "click .start": (e)->
    Uploader.startUpload.call Template.instance(), e
}

Template.uploadForm.onRendered ()->
  Uploader.render.call @

Template.uploadForm.onCreated ()->
  Uploader.init @
  
