
class @ModulesView extends BaseNode

  constructor: ()->
    super
    @.setOrigin .5, .5, .5
     .setAlign .5, .4, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize 900, 600, 1

    #all the rendered module surfaces
    @._currentSurface = null
    @._currentIndex = 0
    @._modules = []


  goToNextModule: ()->
    @.showModule ++@._currentIndex

  showModule: ( index )->
    if @._currentSurface
      @._currentSurface.moveOffstage()
      @._currentSurface.removeAllChildren()
    if @._modules[index]
      surface = SurfaceFactory.get().getModuleSurface(@._modules[index], index)
      @.addChild surface
      surface.moveOnstage()
      @._currentSurface = surface
      @._currentIndex = index
      return
    else
      @.removeAllChildren()
      @.reset()
      Scene.get().goToLessonsPage()

  reset: ()->
    @._currentSurface = null
    @._currentIndex = null
    @._modules = []

  start: ()->
    @._addNextBtn()
    @._currentIndex = 0
    @.showModule 0

  _addNextBtn: ()->
    @.next = new NextBtn()
    @.addChild @.next

  setModules: (modules)->
    @._modules = modules

class NextBtn extends BaseNode
  constructor: ()->
    super

    console.log "Adding a next button"
    console.trace()
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

