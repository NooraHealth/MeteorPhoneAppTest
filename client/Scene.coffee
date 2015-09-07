class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  @init: ()->
    scene = Scene.get()
    scene.init()
    return scene

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
      @.footer = new Footer()

      @.root.addChild @.header
      @.root.addChild @.footer
      #@.footer.hide()

      @.goToLessonsPage()
      @

    setCurriculum: (curriculum)->
      @.curriculum = curriculum
      @.lessons = @.curriculum.getLessonDocuments()
      @.lessonsView.setLessons @.lessons
      @

    goToLessonsPage: ()->
      @.modulesView.hideCurrentSurface()
      @.lessonsView.moveOnstage()
      @.footer.lessonsPageMode()
      @

    goToNextModule: ()->
      @.modulesView.goToNextModule()
      @

    openCurriculumMenu: ()->
      @.header.openCurriculumMenu()
      @

    showModules: (lesson)->
      console.log "about to show mdoules"
      modules = lesson.getModulesSequence()
      @.modulesView.setModules modules
      @.goToModules()
      @

    goToModules: ()->
      @.lessonsView.moveOffstage()
      @.footer.modulesMode()
      @.modulesView.start()
      @

    setContentSrc: (src)->
      @.src = src
      @

    getContentSrc: (filePath)->
      #encoding the m-dash in urls must be done manually
      escaped = encodeURIComponent(filePath)
      correctMdash = '%E2%80%94'
      incorrectMdash = /%E2%80%93/
      if escaped.match incorrectMdash
        escaped = escaped.replace incorrectMdash, correctMdash
      return @.src + escaped

    getPageSize: ()->
      return @.pageSize



