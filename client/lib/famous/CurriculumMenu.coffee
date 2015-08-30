class @CurriculumMenu extends Node

  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.OPEN = 1
    @.CLOSED = 0

    @.items = []

    @.setOrigin .5, .5, .5
     .setMountPoint 1, 1, .5
     .setAlign 1, 0
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize 300, 900
     .setPosition 0, 0, 0

    @.domElement = new DOMElement @

    @.curriculums = Curriculum.find({title:{$ne: "Start a New Curriculum"}})
    @.fillCurriculumList()
    @.positionTransitionable = new Transitionable 0

  setCurriculums: ( curriculums )->
    @.curriculms = curriculums
    @.removeAllItems()
    @.fillCurriculumList()

  fillCurriculumList: ()->
    index = 0
    @.curriculums.forEach (curr)=>
      item = new ListItem(curr , index * 50)
      @.addChild item
      @.items.push item
      index++

  removeAllItems: ()->
    for child in @.getChildren
      @.removeChild child

  onUpdate: ()->
    @.setPosition 0, @.positionTransitionable.get() * 500, 0

  open: ()=>
    console.log "on open"
    console.log @
    console.log @.curriculums
    @.slideMenuTo @.OPEN

  close: ()=>
    @.slideMenuTo @.CLOSED

  toggle: ()=>
    if @.positionTransitionable.get() == @.OPEN
      target = @.CLOSED
    else
      target = @.OPEN

    @.slideMenuTo target

  slideMenuTo: ( target )=>
    @.positionTransitionable.halt()
    @.positionTransitionable.to target, "easeOut", 2000, ()-> console.log "Curriculum Menu toggled"
    @.requestUpdateOnNextTick @

class @ListItem extends Node

  constructor: (@curriculum, @offset)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setMountPoint 0, 0, .5
     .setAlign 0, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .8
     .setAbsoluteSize 0, 40
     .setPosition 0, @.offset, 10

    title = @.curriculum.title
    @.domElement = new DOMElement @,
      tagName: "a"
      content: "#{title}"

    @.domElement.addClass "btn"
    @.domElement.addClass "green"
    @.domElement.addClass "waves-effect"
    @.domElement.addClass "waves-light"

    console.log "Making a list item"
    console.log @

    @.addUIEvent "click"

  getCurrId: ()=>
    return @.curriculum._id

