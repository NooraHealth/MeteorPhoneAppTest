
class @ModulesView extends BaseNode

  constructor: ()->
    super
    @.setOrigin .5, .5, .5
     .setAlign .5, .3, .5
     .setMountPoint .5, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize .8, 1, 1

    #all the rendered module surfaces
    @._currentSurface = null
    @._currentIndex = 0
    @._modules = []

  goToNextModule: ()->
    @.showModule ++@._currentIndex

  hideCurrentSurface: ()->
    if @._currentSurface
      @._currentSurface.moveOffstage()

  showModule: ( index )->
    @.hideCurrentSurface()
    if @._modules[index]
      surface = SurfaceFactory.get().getModuleSurface( @._modules[index], @ )
      surface.moveOnstage()
      @._currentSurface = surface
      @._currentIndex = index
      return
    else
      @.reset()
      Scene.get().goToLessonsPage()

  reset: ()->
    @._currentSurface = null
    @._currentIndex = null
    @._modules = []

  start: ()->
    @._currentIndex = 0
    @.showModule 0

  setModules: (modules)->
    @._modules = modules

