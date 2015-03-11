Template.slideModule.helpers
  imgSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + this.image
