Template.multipleChoiceModule.events
  "click .image-choice": (event, template)->
    #console.log "Image clicked!"
    #answers =  Template.currentData().correct_answer
    #if answers
      #numCorrect = answers.length
    #else
      #numCorrect = 0
    #numSelected = $("img[class~=selected]").length
    #if numSelected >= numCorrect
      #$(event.target).removeClass "selected"
      #return
    #else
    console.log "Clicked a Multiple choice!"
    $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    id = module._id
    $(event.target).fadeTo(500, .75).addClass "disabled"
    handleResponse()
    showNextModuleBtn(module)

Template.multipleChoiceModule.helpers
  secondRow: ()->
    return @.getOptions 3, 6
  firstRow: ()->
    return @.getOptions 0, 3
  module: ()->
    return @


