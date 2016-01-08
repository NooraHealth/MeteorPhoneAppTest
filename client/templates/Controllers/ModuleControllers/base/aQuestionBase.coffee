class @QuestionBase

  constructor: ( @_module )->
    @._completedQuestion = false
    @.audio = new Audio @._module.audioSrc(), "#audio", @._module._id
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio", @._module._id
    @.correctSoundEffect = new Audio Meteor.getContentSrc() + "NooraHealthContent/Audio/correct_soundeffect.mp3", "#correct_soundeffect", @._module._id
    @.incorrectSoundEffect = new Audio Meteor.getContentSrc() + "NooraHealthContent/Audio/incorrect_soundeffect.mp3", "#incorrect_soundeffect", @._module._id

  replay: ()->
    @.stopAllAudio()
    if @._completedQuestion
      @.correctAudio.playWhenReady()
    else
      @.audio.playWhenReady()

  correctResponseButtons: ()->
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> @.isCorrectAnswer $(elem).attr "value"

  incorrectResponseButtons: ()->
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> not @.isCorrectAnswer $(elem).attr "value"

  isCorrectAnswer: ( val )=>
    return val in @._module.correct_answer

  stopAllAudio: ()->
    @.audio.pause()
    @.correctAudio.pause()
 
  begin: ( playIntro )->
    @.audio.playWhenReady()

  end: ()->
    @.stopAllAudio()
    @.resetState()
  
  resetState: ()->
    for btn in @.incorrectResponseButtons()
      if $(btn).hasClass "incorrectly-selected"
        $(btn).removeClass "incorrectly-selected"
      if $(btn).hasClass "faded"
        $(btn).removeClass "faded"
    for btn in @.correctResponseButtons()
      if $(btn).hasClass "correctly-selected"
        $(btn).removeClass "correctly-selected"
      if $(btn).hasClass "expanded"
        $(btn).removeClass "expanded"

