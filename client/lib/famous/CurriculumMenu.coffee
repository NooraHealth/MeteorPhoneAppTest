class @CurriculumMenu extends Node

  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.OPEN = 1
    @.CLOSED = 0

    @.curriculums = Curriculum.find({title:{$ne: "Start a New Curriculum"}})
    console.log "Curriculums"
    console.log @.curriculums

    @.setOrigin .5, .5, .5
     .setMountPoint 1, 1, .5
     .setAlign 1, 1
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize 400, 800

    @.domElement = new DOMElement @

    index = 0
    @.curriculums.forEach (curr)=>
      @.addChild(new ListItem(curr , index * 50))
      index++

    @.positionTransitionable = new Transitionable 0

  onUpdate: ()->
    @.setPosition 0, @.positionTransitionable.get() * 500, 0

  open: ()->
    @.slideMenuTo @.OPEN

  onReceive: ( e, payload )->
    curriculum = payload.node
    Session.set "curriculum_id", curriculum.id

  toggle: ()->
    if @.positionTransitionable.get() == @.OPEN
      target = @.CLOSED
    else
      target = @.OPEN

    @.slideMenuTo target

  slideMenuTo: ( target )->
    @.positionTransitionable.to target, "easeOut", 1000, ()-> console.log "Curriculum Menu toggled"

class ListItem extends Node

  constructor: (@curriculum, offset)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setMountPoint 0, 0, .5
     .setAlign 0, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setProportionalSize .8
     .setAbsoluteSize 0, 40
     .setPosition 0, offset, 0

    title = @.curriculum.title
    @.domElement = new DOMElement @,
      tagName: "a"
      content: "#{title}"

    @.domElement.addClass "btn"
    @.domElement.addClass "green"
    @.addUIEvent "click"


