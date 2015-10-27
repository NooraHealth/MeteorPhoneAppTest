class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      @._lessons = []

    _setCurriculum: ( curriculum )->
      @.curriculum = curriculum
      @._lessons = @.curriculum.getLessonDocuments()
      Session.set "curriculum id", @.curriculum._id
      @

    _getCurriculum: ()->
      id = Session.get "curriculum id"
      return Curriculum.findOne {_id: id}

    getLessons: ()->
      curriculum = @._getCurriculum()
      if not curriculum
        return []
      return curriculum.getLessonDocuments()

    setCurriculum: (curriculum)->
      if Meteor.isCordova
        @.downloadCurriculum curriculum
      else
        @._setCurriculum( curriculum )
      @
    
    downloadCurriculum: ( curriculum )->
      if Meteor.isCordova
        Scene.get().goToLoadingScreen()
        endpoint = @.getContentEndpoint()
        downloader = new ContentInterface curriculum, endpoint
        onSuccess = (entry)=>
          console.log "Success downloading content: ", entry
          #Meteor.user().setContentAsLoaded true
          @._setCurriculum curriculum
          Scene.get().goToLessonsPage()

        onError = (err)->
          console.log "Error downloading content: ", err
          console.log err
          alert "There was an error downloading your content, please log in and try again: ", err
          Meteor.logout()

        downloader.loadContent onSuccess, onError

    getContentEndpoint: () ->
      return @._contentEndpoint

    setContentEndpoint: ( endpoint )->
      @._contentEndpoint = endpoint
      @

    goToLoadingScreen: ()->
      Router.go "loading"
      @

    goToLessonsPage: ()->
      Router.go "home"
      @

    goToNextModule: ()->
      @._modulesController.goToNextModule()
      @

    modulesSequenceController: ()->
      return @._modulesController

    openCurriculumMenu: ()->
      #this is where will open the Ionic side menu
      @

    goToModules: ( lessonId )->
      @._modulesController = new ModulesController lessonId
      Router.go "modules.show", { "_id" : lessonId }

    startModulesSequence: ()->
      @._modulesController.start()

    getModulesSequence: ()->
      if @._modulesController?
        return @._modulesController.getSequence()
      else
        return []

    setContentSrc: (src)->
      @.src = src

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

