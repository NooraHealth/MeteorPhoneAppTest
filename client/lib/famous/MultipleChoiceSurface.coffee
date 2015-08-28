
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface

  constructor: ( @module, index )->
    super( @.module , index )
    @.responses = []

    @.domElement = new DOMElement @, {
      content: "<p>I am multiple choice</p>"
    }

  handleClick: (event)=>
    console.log "Click Event!"
    console.log event
    if event.target.classList.contains "disabled"
      return

    if event.target.classList.contains "image-choice"
      @.handleImageChoiceSelected(event)
    if event.target.name == 'submit_multiple_choice'
      @.handleMultipleChoiceResponseSubmitted(event)

  handleMultipleChoiceResponseSubmitted: (event)->
    ModuleView.handleResponse(@, event)
      
  handleImageChoiceSelected: (event)=>
    answers = @.module.correct_answer
    if !answers
      answers = []
    
    event.target.classList.toggle "selected"

  handleInputUpdate: (event)=>
    console.log "Update Event!"

  handleInputEnd: (event)=>
    console.log "End Event!"


