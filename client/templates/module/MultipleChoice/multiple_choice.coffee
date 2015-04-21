Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    numCorrect = $("img[class~=correct]").length
    numSelected = $("img[class~=selected]").length
    if numSelected >= numCorrect
      $(event.target).removeClass "selected"
      return
    else
      $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    nh_id = module.nh_id
    numPossibleCorrect = module.correct_answer.length
    
    #fade out all the containers of the incorrect options
    [responses, numIncorrect] = expandCorrectOptions(module)

    #Fade out the submit btn
    $(event.target).fadeOut()

    #play the audio depending on whether the user answered correctly or not
    if numIncorrect > 0
      handleFailedAttempt(module, responses )
      playAnswerAudio("incorrect", module)
      updateModuleNav "incorrect"
    else
      handleSuccessfulAttempt(module)
      updateModuleNav "correct"
      playAnswerAudio("correct", module)
    
    showNextModuleBtn(module)

Template.multipleChoiceModule.helpers
  module: ()->
    console.log "GETING MC module ", @
    return @
###
# HELPER FUNCTIONS
###

expandCorrectOptions = (module) ->
    nh_id = module.nh_id
    options = $("img[name=option#{nh_id}]")
    responses = []
    numIncorrect = 0
    for option in options
      
      if $(option).hasClass "selected"
        responses.push $(option).attr "name"

      if not $(option).hasClass "correct"
        $(option).addClass "faded"
      
      else
        $(option).addClass "expanded"
        
        if not $(option).hasClass "selected"
          numIncorrect++
          $(option).addClass "incorrectly_selected"

        else
         $(option).removeClass "selected"
         $(option).addClass "correctly_selected"

    return [responses, numIncorrect]

