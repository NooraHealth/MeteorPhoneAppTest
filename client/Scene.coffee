class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
      @.scene.init()
    return @.scene

  class PrivateScene
    constructor: ()->
    init: ()->
      @.famousScene = FamousEngine.createScene "body"

      @.root = @.famousScene.addChild()
      @.pageSize =
        x: 0
        y: 0
        z: 0

      @.root.addComponent
        onSizeChange: (x, y, z)=>
          console.log "SIZE CHANGE"
          @.pageSize =
            x: x
            y: y
            z: z

      @.camera = new Camera @.famousScene
      @.camera.setDepth 1000

      @.lessonsView = new LessonsView()
      @.modulesView = new ModulesView()
      @.root.addChild @.lessonsView
      @.root.addChild @.modulesView

      @.header = new Header()
      @.root.addChild @.header

      @.goToLessonsPage()
      @

    subscribe: ( obj, func, callback )->

    goToLessonsPage: ()->
      @.modulesView.moveOffstage()
      @.lessonsView.moveOnstage()
      @

    goToNextModule: ()->
      @.modulesView.goToNextModule()
      @

    openCurriculumMenu: ()->
      @.header.openCurriculumMenu()
      @

    setLessons: (lessons)->
      @.lessons = lessons
      @.lessonsView.setLessons lessons
      @

    showModules: (lesson)->
      console.log "about to show mdoules"
      modules = lesson.getModulesSequence()
      @.modulesView.setModules modules
      @.goToModules()
      @

    goToModules: ()->
      @.lessonsView.moveOffstage()
      @.modulesView.moveOnstage()
      @.modulesView.start()
      @

    setContentSrc: (src)->
      @.src = src
      @

    getContentSrc: ()->
      return @.src

    getPageSize: ()->
      console.log "This is the page size"
      console.log @.pageSize
      return @.pageSize

