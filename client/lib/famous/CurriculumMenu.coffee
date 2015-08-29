class @CurriculumMenu extends Node

  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.OPEN = 1
    @.CLOSED = 0

    @.curriculums = Curriculum.find({title:{$ne: "Start a New Curriculum"}})
    @.items = []
    console.log "Curriculums"
    console.log @.curriculums

    @.setOrigin .5, .5, .5
     .setMountPoint 1, 1, .5
     .setAlign 1, 0
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize 300, 900

    @.domElement = new DOMElement @

    index = 0
    @.curriculums.forEach (curr)=>
      item = new ListItem(curr , index * 50)
      @.addChild item
      @.items.push item
      index++

    @.positionTransitionable = new Transitionable 0

  onUpdate: ()->
    @.setPosition 0, @.positionTransitionable.get() * 500, 0

  open: ()->
    #for item in @.items
      #item.open()
    console.log "OPening the curriculum enu"
    @.slideMenuTo @.OPEN

  close: ()->
    #for item in @.items
      #item.close()
    @.slideMenuTo @.CLOSED

  toggle: ()->
    if @.positionTransitionable.get() == @.OPEN
      target = @.CLOSED
    else
      target = @.OPEN

    @.slideMenuTo target

  slideMenuTo: ( target )->
    @.positionTransitionable.to target, "easeOut", 2000, ()-> console.log "Curriculum Menu toggled"
    @.requestUpdate @

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
     .setPosition 0, @.offset, 0

    title = @.curriculum.title
    @.domElement = new DOMElement @,
      tagName: "a"
      content: "#{title}"

    @.domElement.addClass "btn"
    @.domElement.addClass "green"
    @.domElement.addClass "waves-effect"
    @.domElement.addClass "waves-light"
    @.addUIEvent "click"

    @.offsetTransitionable = new Transitionable 1

  onUpdate: ()=>
    @.setPosition 0, @.offsetTransitionable * @.offset, 0

  open: ()=>
    @.offsetTransitionable.to 1, "easeIn", 1000
    @.requestUpdate @

  close: ()=>
    @.offsetTransitionable.to 0, "easeIn", 1000
    @.requestUpdate @

  getCurrId: ()=>
    console.log "Returning id of my curriculum"
    console.log @.curriculum
    return @.curriculum._id

