
class @DeprecatedModulesSequence
  constructor: ( @_lessonId )->
    @._lesson = Lessons.findOne { _id: @._lessonId }
    @._modules = @._lesson.getModulesSequence()
    @._currentIndex = 0

  getSequence: ()->
    return @._modules

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
    Router.go "modules.show",  { _id: @._lessonId }

  setModules: (modules)->
    @._modules = modules

