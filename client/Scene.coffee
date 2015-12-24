
document.addEventListener "resume", ()->
  Scene.get().playAppIntro(true)

class @Scene
  @get: ()->
    if !@.scene
      @.scene = new PrivateScene()
    return @.scene

  class PrivateScene
    constructor: ()->
      if Meteor.isCordova
        @.downloader = new ContentInterface()
        Curriculum.find({}).observe {
          changed: ( newCurr, oldCurr )->
            console.log "CURRICULUM CHANGES"
        }

        Lessons.find({}).observe ({
          changed: ( newLesson, oldLesson )->
            Scene.get().goToLoadingScreen()
            files = []
            files.push newLesson.image
            promise = Scene.get().downloader.downloadFiles files
            promise.then (entry)->
              Scene.get().goToLessonsPage()
            promise.fail (err)->
        })

        Modules.find({}).observe ({
          changed: ( newModule, oldModule )->
            Scene.get().goToLoadingScreen()
            filenames = Scene.get().downloader.moduleUrls newModule
            promise = Scene.get().downloader.downloadFiles filenames
            promise.then (entry)->
              Scene.get().goToLessonsPage()
            promise.fail (err)->
        })
      
      @._contentEndpoint = Meteor.settings.public.CONTENT_SRC
      id = Session.get "curriculum id"
      if id
        curr = Curriculum.findOne { _id : id }
        if curr
          @.setCurriculum curr
      @._hasPlayedIntro = false
      
    stopAudio: ()->
      @.intro.pause()

    playAppIntro: ( force )->
      if not @.intro?
        @.intro = new Audio Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3', "#intro", ""

      if not @.getCurriculum()
        return

      if force or not @._hasPlayedIntro
        @.intro.playWhenReady()
        @._hasPlayedIntro = true

    _setCurriculum: ( curriculum )->
      @.curriculum = curriculum
      Session.setPersistent "current lesson", 0
      Session.setPersistent "curriculum id", @.curriculum._id
      @

    scrollToTop: ()->
      $($(".page-content")[0]).animate { scrollTop: 0 }, "slow"
      @

    getCurriculumId: ()->
      return Session.get "curriculum id"

    getCurriculum: ()->
      id = @.getCurriculumId()
      return Curriculum.findOne {_id: id}

    getLessons: ()->
      curriculum = @.getCurriculum()
      if not curriculum?
        return []
      return curriculum.getLessonDocuments()

    getCurrentLesson: ()->
      currentLesson = Session.get "current lesson"
      if currentLesson?
        return @.getLessons()[currentLesson]
      else
        return @.getLessons()[0]

    incrementCurrentLesson: ()->
      currLesson = Session.get "current lesson"
      nextLesson = ( currLesson + 1 ) % @.getLessons().length
      Session.setPersistent "current lesson", nextLesson
      
    replayMedia: ()->
      @._modulesController.replay()

    setCurriculum: (curriculum)->
      console.log "Is connected?", Meteor.status().connected
      if Meteor.isCordova and Meteor.status().connected# and not ContentInterface.contentAlreadyLoaded curriculum
        console.log "---- OGING TO LOADING SCREEN-----------"
        @.goToLoadingScreen()
        @.downloadCurriculum curriculum
      else
        @.goToLessonsPage()
      @._setCurriculum( curriculum )
      @
    
    downloadCurriculum: ( curriculum )->
      console.log "In download curriculum"
      if Meteor.isCordova
        onSuccess = (entry)=>
          Scene.get().goToLessonsPage()

        onError = (err)->
          console.log "Error downloading content: ", err
          console.log err
          alert "There was an error downloading your content, please log in and try again: ", err
          Meteor.logout()

        console.table "This is the curr", curriculum
        @.downloader.loadContent curriculum, onSuccess, onError

    goToLoadingScreen: ()->
      FlowRouter.go "/loading"
      @

    goToLessonsPage: ()->
      if @._modulesController
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

