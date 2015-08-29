
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface

  constructor: ( @module, index )->
    super( @.module , index )
    @.responses = []
    @.choices = []

    @.domElement = new DOMElement @

    console.log module.options
    for src in @.module.options
      console.log src
      choice = new Choice Scene.get().getContentSrc(src)
      @.addChild choice
      @.choices.push choice

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


class Choice extends Node
  constructor: (@src)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize 100, 100
     
    console.log "SRC: "
    console.log @.src
    @.domElement = new DOMElement @,
      tagName: "img"
      atttributes:
        src: @.src

