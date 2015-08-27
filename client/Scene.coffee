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

      @.root.addComponent {
        onSizeChange: (x, y, z)=>
          @.pageSize = {
            x: x
            y: y
            z: z
          }
          console.log "Set page size: ", @.pageSize
      }
      @

    goToLessonsPage: ()->
      @.modulesView.hide()
      @.lessonsView.show()

    goToNextModule: ()->
      @.modulesView.goToNextModule()

    setLessons: (lessons)->
      @.lessons = lessons
      @.lessonsView.setLessons lessons
      @

    showModules: (lesson)->
      modules = lesson.getModulesSequence()
      @.modulesView.setModules modules
      @.lessonsView.hide()
      @.modulesView.show()

    setContentSrc: (src)->
      @.src = src
      @

    getContentSrc: ()->
      return @.src

    getPageSize: ()->
      console.log "Returning the page size"
      return @.pageSize

