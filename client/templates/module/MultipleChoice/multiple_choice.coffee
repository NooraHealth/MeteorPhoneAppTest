Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    nh_id = module.nh_id
    numPossibleCorrect = module.correct_answer.length
   
    #fade out all the containers of the incorrect options
    numIncorrect = expandCorrectOptions(module)

    #Fade out the submit btn
    $(event.target).fadeOut()

    #play the audio depending on whether the user answered correctly or not
    if numIncorrect > 0
      playAnswerAudio(event.target, module)
  
    showNextModuleBtn(module)


###
# HELPER FUNCTIONS
###

expandCorrectOptions = (module) ->
    nh_id = module.nh_id
    options = $("img[name=option#{nh_id}]")
    numIncorrect = 0
    for option in options
      if not $(option).hasClass "correct"
        $(option).addClass "faded"
      else

        $(option).addClass "expanded"
        
        if not $(option).hasClass "selected"
          #displayIncorrectSticker(module, option)
          numIncorrect += 1
          $(option).addClass "incorrectly_selected"

        else
         $(option).removeClass "selected"
         $(option).addClass "correctly_selected"

    return numIncorrect

#displayCorrectSticker = (module, optionImg)->
  #console.log optionImg
  #console.log "showing correct stcker"
  #optionIndex = $(optionImg).attr "alt"
  #nh_id = module.nh_id
  #console.log $("sticker_correct#{optionIndex}#{nh_id}")
  #$("#sticker_correct#{optionIndex}#{nh_id}").removeClass("hidden")

#displayIncorrectSticker = (module, optionImg)->
  #console.log optionImg
  #console.log $(optionImg)
  #optionIndex = $(optionImg).attr "alt"
  #nh_id = module.nh_id
  #$("#sticker_incorrect#{optionIndex}#{nh_id}").removeClass "hidden"
