Template.videoModule.helpers
  videoSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + this.video
