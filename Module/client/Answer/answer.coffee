Template.answer.helpers
  incorrectAnswerAudio: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + @.incorrect_audio

  correctAnswerAudio: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + @.correct_audio

  imgSrc: ()->
    if _.isEmpty @
      return ""
    else
      return MEDIA_URL + @.image
