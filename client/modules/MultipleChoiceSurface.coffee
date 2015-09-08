
###
# Multiple Choice Surface
###
class @MultipleChoiceSurface
  @get: ( module, parent )->
    if not @.surface
      @.surface = new PrivateSurface module
      parent.addChild @.surface
    else
      @.surface.setModule module

    return @.surface

  class PrivateSurface extends ModuleSurface

    constructor: ( @_module )->
      super( @._module  )

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

      @.title = new TitleBar( @._module.question, { x: 700, y: @.TITLE_HEIGHT } )
      @.submit = new SubmitButton { x: 700, y: @.SUBMIT_HEIGHT }

      @.addChild @.image
      @.addChild @.title
      @.addChild @.submit

      @._grid = new Grid @._module.options.length, @.CHOICES_PER_ROW, @.SIZE, @.MARGIN, @.EDGE_MARGIN
      for src, index in @._module.options
        choice = new Choice( Scene.get().getContentSrc(src) )
        @.locate choice, index, @._module.options.length
        @.addChild choice
        @.choices.push choice
        if src in @._module.correct_answer
          @.correctChoices.push choice

    resetChoices: ()->
      for choice, i in @.choices
        newChoice = @._module.options[i]
        choice.setSrc Scene.get().getContentSrc( newChoice )
        choice.reset()

    resetTitle: ()->
      @.title.setTitle @._module.question

    setModule: ( module )->
      @._module = module
      super
      @.resetChoices()
      @.resetTitle()

    choicesBoxSize: ()=>
      return [ @.SIZE[0], ( @.SIZE[1] - @.TITLE_HEIGHT - @.SUBMIT_HEIGHT)]

    locate: ( choice, index, totalChoices )->

      numRows = @._grid.getNumRows()

      horizontalSpace = @._grid.getAvailableSpace Grid.X
      verticalSpace = @._grid.getAvailableSpace Grid.Y

      xDimension = horizontalSpace / @.CHOICES_PER_ROW
      yDimension = verticalSpace / numRows
      if yDimension > xDimension
        yDimension = xDimension

      choice.setSizeMode "absolute", "absolute", "absolute"
      choice.setAbsoluteSize xDimension, yDimension, 1

      row = @._grid.getRow index
      col = @._grid.getCol index

      location = @._grid.location row, col, [ xDimension, yDimension ]

      choice.setPosition location.x, location.y + @.TITLE_HEIGHT

    onReceive: ( e, payload )=>
      target = payload.node
      if e == 'click'
        if target instanceof SubmitButton
          @.audio.pause()
          @.presentCorrectResponses()

        if target instanceof Choice
          if target in @.responses
            @.responses = @.responses.filter (choice)-> choice isnt target
          else
            @.responses.push target

    presentCorrectResponses: ()->
      audio = null
      for choice in @.correctChoices
        choice.expand()
        if choice in @.responses
          choice.markAsCorrect()
        else
          audio = @.incorrectAudio
          choice.markAsIncorrect()

      for response in @.responses
        if response not in @.correctChoices
          audio = @.incorrectAudio
          response.markAsIncorrect()

      audio ?= @.correctAudio
      audio.play()

  class Choice extends BaseNode
    constructor: ( @src, @position )->
      @[name] = method for name, method of Node.prototype
      Node.apply @

      @.setOrigin .5, .5, .5
      .setAlign 0, 0, .5
      .setMountPoint 0, 0, .5
      .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
      
      @.domElement = new DOMElement @
      
      @.domElement.addClass "align-center"
      @.domElement.addClass "image-choice"
      @.setContent( @.src )
      
      @.scale = new Scale @
      @.scale.set 1, 1, 1
      @.addUIEvent "click"

    reset: ()->
      @.scale.set 1, 1, 1
      if @.domElement.hasClass "selected"
        @.domElement.removeClass "selected"
      if @.domElement.hasClass "correctly-selected"
        @.domElement.removeClass "correctly-selected"
      if @.domElement.hasClass "incorrectly-selected"
        @.domElement.removeClass "incorrectly-selected"

    setContent: ( src )=>
      @.domElement.setContent "<img class='image-choice' src='#{src}' />"

    setSrc: ( src )->
      @.src = src
      @.setContent src

    onReceive: ( e, payload )=>
      if e == 'click'
        @.toggleClass @.domElement, "selected"

    expand: ()=>
      @.scale.set 1.2, 1.2, 1, {curve: "easeIn", duration: 1000}

    markAsIncorrect: ()=>
      if @.domElement.hasClass "selected"
        @.domElement.removeClass "selected"
      @.domElement.addClass "incorrectly-selected"

    markAsCorrect: ()=>
      console.log "Marking as correct"
      if @.domElement.hasClass "selected"
        @.domElement.removeClass "selected"
      @.domElement.addClass "correctly-selected"


  class SubmitButton extends ResponseButton
    constructor: ( @size )->
      super

      @.setOrigin .5, .5, .5
      .setAlign 0, .95, .5
      .setMountPoint 0, 1, .5
      .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
      .setAbsoluteSize @.size.x, @.size.y

      @.domElement.setContent "SUBMIT"
      @.domElement.addClass "blue"

      @.addUIEvent "click"

