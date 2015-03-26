Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    nh_id = module.nh_id
    optionContainers = $("img[name=option#{nh_id}]")
    numIncorrect = 0
    console.log module
    numPossibleCorrect = module.correct_answer.length
    
    $(event.target).fadeOut()
    console.log optionContainers

    for option in optionContainers
      if not $(option).hasClass "correct"
        $(option).fadeOut()
      else
        if not $(option).hasClass "selected"
          numIncorrect += 1

    if numIncorrect > 0
      playAnswerAudio(event.target, module)


