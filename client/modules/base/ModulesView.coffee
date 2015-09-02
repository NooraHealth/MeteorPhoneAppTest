
class @ModulesView extends BaseNode

  constructor: ()->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, .4, .5
     .setMountPoint .5, .5, .5
     #.setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .8, .7, 1
     #.setAbsoluteSize 600, 500, 0
     .setPosition 0, 0, 0

    #all the rendered module surfaces
    @.surfaces = []
    @._addNextBtn()

    @.positionTransitionable = new Transitionable 1
    @.requestUpdateOnNextTick()

  onUpdate: ()->
    pageWidth = Scene.get().getPageSize().x
    @.setPosition @.positionTransitionable.get() * pageWidth, 0, 0

  moveOffstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 1, 'easeOut', 500
    @.hide()
    @.requestUpdateOnNextTick(@)

  moveOnstage: ()->
    @.positionTransitionable.halt()
    @.positionTransitionable.to 0, 'easeIn', 500
    @.show()
    @.requestUpdateOnNextTick(@)

  goToNextModule: ()->
    index = @.currentIndex + 1
    @.showModule index

  showModule: (index)->
    if @.currentIndex? and @.surfaces[@.currentIndex]
      @.surfaces[@.currentIndex].moveOffstage()
    if @.surfaces[index]
      @.surfaces[index].moveOnstage()
      @.currentIndex = index
      return
    else
      Scene.get().goToLessonsPage()

  start: ()->
    if not @.currentIndex
      @.showModule 0
    #TODO this is a very temporary solution,
    #update this ASAP
    else
      @.showModule ++@.currentIndex

  _removeNextBtn: ()->
    if @.next
      @.removeChild @.next

  _addNextBtn: ()->
    @.next = new NextBtn()
    @.addChild @.next

  #TODO This is a very temporary solution until I can
  #find a better workaround the famous removeChild bug
  #for prototype purposes
  setModules: (modules)->
    @._modules = modules
    #@._removeNextBtn()
    #@._addNextBtn()
    #for surface in @.surfaces
      #bool = @.removeChild surface

    for module, index in modules
      surface = SurfaceFactory.get().getModuleSurface(module, index)
      @.surfaces.push surface
      @.addChild surface

class NextBtn extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @
    console.log "Building a NextBtn"

    x = Scene.get().getPageSize().x
    y = Scene.get().getPageSize().y

    @.setOrigin .5, .5, .5
     .setMountPoint 1, 1, .5
     .setAlign 1, 1, .5
     .setSizeMode "absolute", "absolute", "absolute"
     .setAbsoluteSize 200, 50, 0
     .setPosition 40, 100, 20

    @.domElement = ResponseButton.getButtonDomElement(@)
    @.domElement.setContent "NEXT <i class='mdi-navigation-arrow-forward medium'/>"
    @.addUIEvent "click"

  onReceive: (e, payload) ->
    if e == 'click'
      Scene.get().goToNextModule()
      payload.stopPropagation()

