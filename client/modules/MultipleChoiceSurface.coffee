
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface

  constructor: ( @module, index )->
    super( @.module , index )

    @.responses = []
    @.choices = []
    @.correctChoices = []

    @.SIZE = [ 700, 500, 1 ]
    @.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize @.SIZE[0], @.SIZE[1], @.SIZE[2]

    @.CHOICES_PER_ROW = 3
    @.COLUMNS = 2
    @.MARGIN = 30
    @.EDGE_MARGIN = 20
    @.TITLE_HEIGHT = 60
    @.SUBMIT_HEIGHT = 50

    @.domElement = new DOMElement @
    @.domElement.addClass "card"

    title = new TitleBar( @.module.question, { x: 700, y: @.TITLE_HEIGHT } )
    submit = new SubmitButton { x: 700, y: @.SUBMIT_HEIGHT }

    @.addChild title
    @.addChild submit

    for src, index in @.module.options
      choice = new Choice( Scene.get().getContentSrc(src) )
      @.locate choice, index, @.module.options.length
      @.addChild choice
      @.choices.push choice
      if src in @.module.correct_answer
        @.correctChoices.push choice

  choicesBoxSize: ()=>
    return [ @.SIZE[0], ( @.SIZE[1] - @.TITLE_HEIGHT - @.SUBMIT_HEIGHT)]

  locate: ( choice, index, totalChoices )->

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

  onReceive: ( e, payload )=>
    if e == 'click'
      if payload.node instanceof SubmitButton
        @.presentCorrectResponses()

      if payload.node instanceof Choice
        @.responses.push payload.node
        console.log "Current responses", @.responses

  presentCorrectResponses: ()->
    for choice in @.correctChoices
      choice.expand()
      if choice in @.responses
        choice.markAsCorrect()

class Choice extends Node
  constructor: ( @src, @position )->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, .5
     .setMountPoint 0, 0, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     
    @.domElement = new DOMElement @,
      content: "<img src='#{src}' class='image-choice'></img>"
    @.domElement.addClass "align-center"
    
    @.addUIEvent "click"

  onReceive: ( e, payload )=>
    if e == 'click'
      Utilities.toggleClass @.domElement, "selected"

  expand: ()->
    console.log "Scaling"
    @.setScale 1.1, 1.1, 1

  markAsCorrect: ()->
    @.domElement.removeClass "selected"
    @.domElement.addClass "correctly-selected"

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

class SubmitButton extends ResponseButton
  constructor: ( @size )->
    super

    @.setOrigin .5, .5, .5
     .setAlign 0, 1, .5
     .setMountPoint 0, 1, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize @.size.x, @.size.y

     @.domElement.setContent "SUBMIT"
     @.domElement.addClass "blue"

     @.addUIEvent "click"

