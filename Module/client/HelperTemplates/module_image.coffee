Template.moduleImage.helpers
  imageSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + @.image
