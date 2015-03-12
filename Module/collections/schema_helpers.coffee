Lessons.helpers {
  imgSrc: ()->
    return MEDIA_URL+ @.image

  audioSrc: ()->
    return MEDIA_URL + @.audio

  incorrectAnswerAudio: ()->
    return MEDIA_URL + @.incorrect_audio

  correctAnswerAudio: ()->
    return MEDIA_URL + @.correct_audio
  
  videoSrc: ()->
    return MEDIA_URL + this.video
