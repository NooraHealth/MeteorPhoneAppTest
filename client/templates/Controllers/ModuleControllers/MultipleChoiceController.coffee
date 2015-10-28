
###
# Multiple Choice Surface
###
class @MultipleChoiceController extends QuestionBase
  constructor: ( @_module )->
    super( @._module  )
    @._responses = []

  correctResponseButtons: ()->
    return $("#" + @._module._id).find(".correct")

  incorrectResponseButtons: ()->
    #return $("#" + @._module._id).find(".response").filter ( elem )=> $(elem).val() not in @._module.correct_answer
    return $("#" + @._module._id).find(".response").filter ( i, elem )=> not $(elem).hasClass "correct"

  responseRecieved: ( target )->

    if $(target).hasClass "correct"
      $(target).addClass "correctly-selected"

      if target not in @._responses
        @._responses.push target

      if @._responses.length == @._module.correct_answer.length
        Audio.playAudio "#correct_soundeffect", ()=> @.correctAudio.playWhenReady()
        correctResponseButtons = @.correctResponseButtons()
        incorrectResponseButtons = @.incorrectResponseButtons()
        console.log correctResponseButtons
        console.log incorrectResponseButtons
        for btn in correctResponseButtons
          $(btn).addClass "expanded"

        for btn in incorrectResponseButtons
          $(btn).addClass "faded"
      else
        Audio.playAudio "#correct_soundeffect"

    else
      Audio.playAudio "#incorrect_soundeffect", null
      $(target).addClass "incorrectly-selected"



