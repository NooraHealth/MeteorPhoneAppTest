Modules.helpers {
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

  isCorrectAnswer: (response)->
    return response in @.correct_answer

  getOptionObjects: ()->
   return {option: option, optionImgSrc: MEDIA_URL + option } for option in @.options

  option: (i)->
    return @.options[i]

  isVideoModule: ()->
    return @.type == "VIDEO"

  isBinaryModule: ()->
    return @.type == "BINARY"

  isMultipleChoiceModule: ()->
    return @.type == "MULTIPLE_CHOICE"

  isSlideModule: ()->
    return @.type == "SLIDE"
  
  isGoalChoiceModule: ()->
    return @.type == "GOAL_CHOICE"

  isScenario: ()->
    return @.type == "SCENARIO"

  isLastModule: ()->
    return @.next_module == '-1' or @.next_module == -1

  nextModule: ()->
    return Modules.findOne {nh_id: @.next_module}
    
}

