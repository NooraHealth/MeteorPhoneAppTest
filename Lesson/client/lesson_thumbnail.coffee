Template.lessonThumbnail.helpers
  imageURL: ()->
    if _.isEmpty(@)
      return ""
    else
      return MEDIA_URL+ @.image
    



