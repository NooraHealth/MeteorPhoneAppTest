Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    nh_id = module.nh_id
    numPossibleCorrect = module.correct_answer.length
   
    #fade out all the containers of the incorrect options
    numIncorrect = displayOnlyCorrectOptions(module)

    #Fade out the submit btn
    $(event.target).fadeOut()

    #play the audio depending on whether the user answered correctly or not
    if numIncorrect > 0
      playAnswerAudio(event.target, module)
  
    showNextModuleBtn(module)


###
# HELPER FUNCTIONS
###

displayOnlyCorrectOptions = (module) ->
    nh_id = module.nh_id
    optionContainers = $("img[name=option#{nh_id}]")
    numIncorrect = 0
    for option in optionContainers
      if not $(option).hasClass "correct"
        $(option).fadeOut()
      else
        if not $(option).hasClass "selected"
          numIncorrect += 1

    return numIncorrect
