
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

  @getOptions: ( module, start, end )->
    url = Meteor.NooraClient.getContentSrc()

    if not module.options
      return []

    isCorrect = ( option )=>
      return option in module.correct_answer

    newArr = ({option: option, optionImgSrc: url + option, nh_id: module.nh_id, i: i, correct: isCorrect(option)} for option, i in module.options when i >= start and i < end)
    return {options: newArr}

  @option: ( module, i )->
    return module.options[i]



