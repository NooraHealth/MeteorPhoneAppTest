class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  @init: ()->
    scene = Scene.get()
    if not scene.alreadyInitialized()
      scene.init()
    return scene

  class PrivateScene
    constructor: ()->
      @._alreadyInitialized = false

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

      @.goToLessonsPage()
      @._alreadyInitialized = true
      @

    alreadyInitialized: ()->
      return @._alreadyInitialized

    _setCurriculum: ( curriculum )->
      console.log "In _setCurriculum"
      @.curriculum = curriculum
      @.lessons = @.curriculum.getLessonDocuments()
      console.log "Settng the lessons of lessonsVIew"
      console.log @.lessons
      @.lessonsView.setLessons @.lessons
      @

    setCurriculum: (curriculum)->
      if Meteor.isCordova
        @.downloadCurriculum curriculum
      else
        @._setCurriculum( curriculum )
      @
    
    downloadCurriculum: ( curriculum )->
      if Meteor.isCordova
        FlowRouter.go "/loading"
        endpoint = @.getContentEndpoint()
        downloader = new ContentInterface curriculum, endpoint
        onSuccess = (entry)=>
          console.log "Success downloading content: ", entry
          #Meteor.user().setContentAsLoaded true
          @._setCurriculum curriculum
          FlowRouter.go "/"

        onError = (err)->
          console.log "Error downloading content: ", err
          console.log err
          alert "There was an error downloading your content, please log in and try again: ", err
          #Meteor.user().setContentAsLoaded false
          Meteor.logout()

        downloader.loadContent onSuccess, onError

    getContentEndpoint: () ->
      return @._contentEndpoint

    setContentEndpoint: ( endpoint )->
      @._contentEndpoint = endpoint
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
      console.log "Getting the content src of ", filePath
      escaped = encodeURIComponent(filePath)
      correctMdash = '%E2%80%94'
      incorrectMdash = /%E2%80%93/
      if escaped.match incorrectMdash
        escaped = escaped.replace incorrectMdash, correctMdash
      console.log "final escaped ", escaped
      return @.src + escaped

    getPageSize: ()->
      return @.pageSize
    
    getFooter: ()->
      return @.footer
    
    curriculumIsSet: ()->
      return @.curriculum?

