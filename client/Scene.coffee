
document.addEventListener "resume", ()->
  Scene.get().playAppIntro(true)

class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      @._lessons = new ReactiveArray()
      @._contentEndpoint = Meteor.settings.public.CONTENT_SRC
      id = Session.get "curriculum id"
      if id
        curr = Curriculum.findOne { _id : id }
        if curr
          @.setCurriculum curr
      @.intro = new Audio "http://p2.noorahealth.org/AppIntro.mp3", "#intro", ""
      @._hasPlayedIntro = false
      
    notify: ( event )->
      if event == "SUBSCRIPTIONS_READY"
        Scene.get().playAppIntro()
        if @.getCurriculum()
          @._lessons = @.getCurriculum().getLessonDocuments()
      if event == "SUBSCRIPTIONS_READY" and @._downloadContentWhenSubscriptionsReady
        @.downloadCurriculum @.getCurriculum()
        @._downloadContentWhenSubscriptionsReady = false

    stopAudio: ()->
      @.intro.pause()

    playAppIntro: ( force )->
      if force or not @._hasPlayedIntro
        @.intro.playWhenReady()
        @._hasPlayedIntro = true

    _setCurriculum: ( curriculum )->
      @.curriculum = curriculum
      Session.setPersistent "current lesson", 0
      Session.setPersistent "curriculum id", @.curriculum._id
      @

    addToLessons: (lessonId)->
      lesson = Lessons.findOne { _id: lessonId }
      @._lessons.push lesson

    scrollToTop: ()->
      $($(".page-content")[0]).animate { scrollTop: 0 }, "slow"

    getCurriculumId: ()->
      return Session.get "curriculum id"

    getCurriculum: ()->
      id = @.getCurriculumId()
      return Curriculum.findOne {_id: id}

    getLessons: ()->
      curriculum = @.getCurriculum()
      if not curriculum
        return []
      return curriculum.getLessonDocuments()

    getCurrentLesson: ()->
      currentLesson = Session.get "current lesson"
      if currentLesson?
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
      console.log "Setting the curriculum!", curriculum
      if Meteor.isCordova and not ContentInterface.contentAlreadyLoaded curriculum
        console.log "---- OGING TO LOADING SCREEN-----------"
        @.goToLoadingScreen()
        @._downloadContentWhenSubscriptionsReady = true
      else
        @.goToLessonsPage()
      @._setCurriculum( curriculum )
      @
    
    downloadCurriculum: ( curriculum )->
      if Meteor.isCordova
        endpoint = @.getContentEndpoint()
        downloader = new ContentInterface curriculum, endpoint
        onSuccess = (entry)=>
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
      FlowRouter.go "/loading"
      @

    goToLessonsPage: ()->
      console.log "Goingt o modulespage"
      if @._modulesController
        console.log "Stopping all audio"
        @._modulesController.stopAllAudio()

      FlowRouter.go "/"
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
      lesson = Lessons.findOne { _id: lessonId }
      @._modulesController = new ModulesController lessonId
      FlowRouter.go "/modules/" +  lesson._id

    startModulesSequence: ()->
      @._modulesController.start()

    getModuleSequenceController: ()->
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
      escaped = encodeURIComponent(filePath)
      correctMdash = '%E2%80%94'
      incorrectMdash = /%E2%80%93/
      if escaped.match incorrectMdash
        escaped = escaped.replace incorrectMdash, correctMdash
      return @.src + escaped

    getPageSize: ()->
      return @.pageSize
    
    getFooter: ()->
      return @.footer
    
    curriculumIsSet: ()->
      return @.curriculum?

