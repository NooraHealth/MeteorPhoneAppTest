
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface

  constructor: (@module)->
    super(Template.multipleChoiceModule, @.module)
    @.responses = []

  handleClick: (event)=>
    console.log "Click Event!"
    console.log event
    if event.target.classList.contains "image-choice"
      @.handleImageChoiceSelected(event)
    if event.target.name == 'submit_multiple_choice'
      @.handleMultipleChoiceResponseSubmitted(event)

  handleMultipleChoiceResponseSubmitted: (event)->
    ModuleView.handleResponse(@, null)

  handleImageChoiceSelected: (event)=>
    answers = @.module.correct_answer
    if !answers
      answers = []
    
    event.target.classList.toggle "selected"

  handleInputUpdate: (event)=>
    console.log "Update Event!"

  handleInputEnd: (event)=>
    console.log "End Event!"


