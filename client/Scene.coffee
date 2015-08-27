class @Scene
  @get: ()->
    @.scene ?= new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      @.famousScene = FamousEngine.createScene "body"

      @.root = @.famousScene.addChild()

      @.camera = new Camera @.famousScene
      @.camera.setDepth 1000

      @.lessonsView = new LessonsView()
      @.modulesView = new ModulesView()
      @.root.addChild @.lessonsView
      @.root.addChild @.modulesView

      @.header = new Header()
      @.root.addChild @.header
      @

    setLessons: (lessons)->
      @.lessons = lessons
      @.lessonsView.setLessons lessons
      @

    showModules: (lesson)->
      console.log "about to show the modules of ", lesson
      modules = lesson.getModulesSequence()
      console.log modules
      @.modulesView.setModules modules
      @.lessonsView.hide()
      @.modulesView.show()

    setContentSrc: (src)->
      @.src = src
      @

    getContentSrc: ()->
      console.log @.src
      return @.src


