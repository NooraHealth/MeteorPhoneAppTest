
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface

  constructor: ( @module, index )->
    super( @.module , index )
    @.responses = []
    @.choices = []

    @.SIZE = [ 700, 500, 1 ]
    @.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize @.SIZE[0], @.SIZE[1], @.SIZE[2]

    @.CHOICES_PER_ROW = 3
    @.COLUMNS = 2
    @.MARGIN = 30
    @.EDGE_MARGIN = 30
    @.TITLE_HEIGHT = 60
    @.SUBMIT_HEIGHT = 60

    @.domElement = new DOMElement @,
      
    @.domElement.addClass "card"

    title = new TitleBar @.module.question, { x: 700, y: @.TITLE_HEIGHT }
    @.addChild title

    for src, index in @.module.options
      choice = new Choice( Scene.get().getContentSrc(src) )
      @.locate choice, index, @.module.options.length
      @.addChild choice
      @.choices.push choice

  choicesBoxSize: ()=>
    return [ @.SIZE[0], ( @.SIZE[1] - @.TITLE_HEIGHT - @.SUBMIT_HEIGHT)]

  locate: ( choice, index, totalChoices )->
    console.log totalChoices
    console.log @.choicesBoxSize()

    numRows = Utilities.getNumRows totalChoices, @.CHOICES_PER_ROW

    horizontalSpace = Utilities.getAvailableSpace @.CHOICES_PER_ROW, @.MARGIN, @.EDGE_MARGIN, @.choicesBoxSize()[0]
    verticalSpace = Utilities.getAvailableSpace numRows, @.MARGIN, @.EDGE_MARGIN, @.choicesBoxSize()[1]

    xDimension = horizontalSpace / @.CHOICES_PER_ROW
    yDimension = verticalSpace / numRows
    if yDimension > xDimension
      yDimension = xDimension

    choice.setSizeMode "absolute", "absolute", "absolute"
    choice.setAbsoluteSize xDimension, yDimension, 1

    row = Utilities.getRow index, @.CHOICES_PER_ROW
    col = Utilities.getCol index, @.CHOICES_PER_ROW

    x = Utilities.getPosition col, xDimension, @.MARGIN, @.EDGE_MARGIN
    y = Utilities.getPosition row, yDimension, @.MARGIN, @.EDGE_MARGIN

    choice.setPosition x, y + @.TITLE_HEIGHT

  handleClick: (event)=>
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
  constructor: (@src, @position)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, .5
     .setMountPoint 0, 0, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     
    @.domElement = new DOMElement @,
      content: "<img src='#{src}' class='image-choice'></img>"

class TitleBar extends Node
  constructor: ( @title, @size )->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, .5
     .setMountPoint 0, 0, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize @.size.x, @.size.y
    
    @.domElement = new DOMElement @,
      content: "#{@.title}"

    @.domElement.addClass "card-content"
    @.domElement.addClass "flow-text"
    @.domElement.addClass "grey-text"
    @.domElement.addClass "text-darken-2"

