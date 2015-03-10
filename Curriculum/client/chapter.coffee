Template.chapter.helpers
  imageURL: ()->
    if _.isEmpty(@)
      console.log "is empty!"
      console.log @
      return ""
    else
      console.log "getting image url"
      console.log @
      return MEDIA_URL+ @.image
