Template.audio.helpers
  audioSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + this.audio
