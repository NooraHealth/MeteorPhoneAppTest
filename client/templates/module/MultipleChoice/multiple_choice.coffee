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
    $(event.target).toggleClass "selected"

  "click [name^=submit_multiple_choice]": (event, template)->
    module = template.data
    id = module._id
    $(event.target).fadeTo(500, .75).addClass "disabled"
    handleResponse()
    showNextModuleBtn(module)

Template.multipleChoiceModule.helpers
  secondRow: ()->
    console.log "SECOND ROW"
    console.log @.getOptions 3,6
    return @.getOptions 3, 6
  firstRow: ()->
    console.log "FIRST ROW"
    console.log @.getOptions 0,3
    return @.getOptions 0, 3
  module: ()->
    return @


