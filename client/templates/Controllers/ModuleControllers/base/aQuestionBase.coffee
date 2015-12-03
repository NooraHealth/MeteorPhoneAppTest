class @QuestionBase
  constructor: ( @_module )->
    @._completedQuestion = false
    @.audio = new Audio @._module.audioSrc(), "#audio", @._module._id
    @.correctAudio = new Audio @._module.correctAnswerAudio(), "#correctaudio", @._module._id
    @.correctSoundEffect = new Audio "http://p2.noorahealth.org/correct_soundeffect.mp3", "#correct_soundeffect", @._module._id
    @.incorrectSoundEffect = new Audio "http://p2.noorahealth.org/incorrect_soundeffect.mp3", "#incorrect_soundeffect", @._module._id
    if @._module.type == "SCENARIO"
      introAudio = '/ScenarioIntro.mp3'
    if @._module.type == "BINARY"
      introAudio = '/BinaryIntro.mp3'
    if @._module.type == "MULTIPLE_CHOICE"
      introAudio = '/MCIntro.mp3'

    @.intro = new Audio "http://p2.noorahealth.org"+introAudio, "#intro", @._module._id

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
    @.intro.pause()

  begin: ()->
    @.intro.playWhenReady( @.audio.playWhenReady )
 
  end: ()->
    @.stopAllAudio()

    @.resetState()
    ModulesController.stopShakingNextButton()
  
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

