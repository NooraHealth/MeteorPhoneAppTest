class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      @._lessons = []
      @._contentEndpoint = Meteor.settings.public.CONTENT_SRC
      id = Session.get "curriculum id"
      if id
        curr = Curriculum.findOne { _id : id }
        if curr
          @.setCurriculum curr

    _setCurriculum: ( curriculum )->
      @.curriculum = curriculum
      @._lessons = @.curriculum.getLessonDocuments()
      Session.setPersistent "current lesson", 0
      Session.setPersistent "curriculum id", @.curriculum._id
      @

    scrollToTop: ()->
      $($(".page-content")[0]).animate { scrollTop: 0 }, "slow"

    getCurriculum: ()->
      id = Session.get "curriculum id"
      return Curriculum.findOne {_id: id}

    getLessons: ()->
      curriculum = @.getCurriculum()
      if not curriculum
        return []
      return curriculum.getLessonDocuments()

    getCurrentLesson: ()->
      currentLesson = Session.get "current lesson"
      if currentLesson
        return @._lessons[currentLesson]
      else
        return @._lessons[0]

    incrementCurrentLesson: ()->
      currLesson = Session.get "current lesson"
      nextLesson = ( currLesson + 1 ) % @._lessons.length
      Session.setPersistent "current lesson", nextLesson

    replayMedia: ()->
      console.log @._modulesController
      @._modulesController.replay()

    setCurriculum: (curriculum)->
      if Meteor.isCordova and not ContentInterface.contentAlreadyLoaded curriculum
        console.log "about to download the curriculum", curriculum
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
      return Meteor.settings.public.CONTENT_SRC

    goToLoadingScreen: ()->
      FlowRouter.go "loading"
      @

    goToLessonsPage: ()->
      FlowRouter.go "home"
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
      lesson = Lessons.findOne {_id: lessonId}
      @._modulesController = new ModulesController lessonId
      FlowRouter.go "/modules/" +  lesson._id

    startModulesSequence: ()->
      @._modulesController.start()

    getModuleSequenceController: ()->
      console.log "returning modeules sequence controller"
      return @._modulesController

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

