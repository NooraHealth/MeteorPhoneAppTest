

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

{ LessonsPageModel } = require '../models/lessons/LessonsPage.coffee'

{ Award } = require('../../ui/components/lessons/popups/award.coffee')

{ Audio } = require('../../ui/components/shared/audio.coffee')

{ IntroductionToQuestions } = require('../../ui/components/lessons/popups/introduction_to_questions.coffee')

class LessonsPageController
  ## ------------- PUBLIC METHODS ------------ ##

  onFinishExplanation: (module, pos, completed, src) ->
    isCurrent = @model.isCurrentModule module
    if isCurrent
      @model.animate "nextButton", true
    @trackAudioStopped( pos, completed, src )

  onLevelSelected: ( index ) ->
    @model.startLevel index
    #@model.goToNextLesson()
    #lessons = @model.getCurrentLessons()
    #if lessons.length > 0
    #else
      #swal {
        #title: "Oops!"
        #text: "We don't have lessons available for that level yet"
      #}

  ##TODO: Change the way context is passed here
  onChoice: (self, type, showAlert) ->
    return (choice) ->
      module = self.model.getCurrentModule()
      if type is "CORRECT"
        self.playAudio(ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 1)
        alertType = 'success'
      else
        self.playAudio(ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO"), 1)
        alertType = 'error'
      if showAlert
        language = AppState.getLanguage()
        swal {
          title: ""
          type: alertType
          timer: 3000
          confirmButtonText: AppState.translate "ok", language
        }

      #analytics
      lesson = self.model.getCurrentLesson()
      text = if module?.title then module?.title else module?.question
      analytics.track "Responded to Question", {
        moduleId: module._id
        moduleText: text
        choice: choice
        lessonTitle: lesson.title
        lessonId: lesson._id
        condition: self.condition
        language: self.language
        type: type
      }

  onCompletedQuestion: (module) ->
    @stopAudio()
    audio = @playAudio ContentInterface.getSrc(module.correct_audio, "AUDIO"), 1, @onFinishExplanation.bind(@, module), @onFinishExplanation.bind(@, module)
    @setCurrentAudio audio
    @

  @celebrateCompletion: ->
    onConfirm = ()=>
      if @model.isLastLesson()
        @goHome(null, true)
      else
        @model.goToNextLesson()
        @autoplayMedia()

    onCancel = ()=>
      @goHome(null, false)
    
    if @model.onLastLesson()
      new Award(@language).sendAward( null, null, lessonsComplete, totalLessons)
      @goHome( null, true )
    else
      new Award(@language).sendAward( onConfirm, onCancel, lessonsComplete, totalLessons )

  @onNextButtonClicked = =>
    lessonComplete = @model.onLastModule()
    currentModule = @model.getCurrentModule()
    @destroyAudio()
    if currentModule.type == "VIDEO"
      @stopVideo currentModule

    if @model.onLastModule()
      @celebrateCompletion()
    else
      @model.goToNextModule()
      @autoplayMedia()

  @onReplayButtonClicked = =>
    @getCurrentAudio().replay()

  @onVideoEnd = =>
    if not @model.onLastModule() and not @isHomePage()
      @showIntroductionToQuestions()
  
  ## ------------- PRIVATE METHODS ------------ ##
  
  constructor: ( @curriculum, @language, @condition ) ->
    @model = new LessonsPageModel @curriculum, @language, @condition
    @liveAudio = []

    @showIntroductionToQuestions = ->
      onConfirm = ()=>
        @model.goToNextModule()
        @autoplayMedia()

      onCancel = ()=>

      new IntroductionToQuestions().send( onConfirm, onCancel, @language )

    @setCurrentAudio = (audio) ->
      @currentAudio = audio
      @

    @getCurrentAudio = ->
      return @currentAudio

    @playAudio = (src, volume, whenFinished, whenPaused) ->
      audio = new Audio src, volume
      audio.play whenFinished, whenPaused
      @liveAudio.push audio
      return audio

    @stopAudio = ->
      @getCurrentAudio().stop()

    @destroyAudio = ->
      for audio in @liveAudio
        audio.destroy()
      @liveAudio = []

    @stopVideo = ( module )->
      $("#" + module._id).find("video")[0]?.pause()

    @playVideo = ( module )->
      $("#" + module._id).find("video")[0]?.play()

    @startLesson = ( index )->
      @getCurrentLevel().currentLessonsSequence().goTo index
      #@setOnHomePage false
      @initializeSwiper()

    @goHome = ( event, completedLevel) ->
      lesson = @model.getCurrentLesson()
      module = @model.getCurrentModule()
      text = if module?.title then module?.title else module?.question
      analytics.track "Left Lesson For Home", {
        lessonTitle: lesson?.title
        lessonId: lesson?._id
        lastModuleId: module?._id
        lastModuleText: text
        lastModuleType: module?.type
        completedLevel: completedLevel
        numberOfModulesInLesson: lesson?.modules.length
      }
      if completedLevel then @model.goToNextLevel()
      @destroyAudio()

    @autoplayMedia = ->
      module = @model.getCurrentModule()
      if module.type == "VIDEO"
        @playVideo module
      if module.hasAudio()
        onFinishAudio = if module.hasExplanation() then @trackAudioStopped else @onFinishExplanation.bind(@, module)
        audio = @playAudio ContentInterface.getSrc(module.audio, "AUDIO"), 1, onFinishAudio, onFinishAudio
        @setCurrentAudio audio

    @trackAudioStopped = (pos, completed, src) ->
      lesson = @getCurrentLevel().currentLessonsSequence().getCurrentItem().lesson
      module = @getCurrentLevel().currentModulesSequence().getCurrentItem()
      text = if module?.title then module?.title else module?.question
      analytics.track "Audio Stopped", {
        moduleText: text
        audioSrc: src
        moduleId: module?._id
        language: @language
        condition: @condition
        time: pos
        completed: completed
        lessonTitle: lesson?.title
        lessonId: lesson?._id
      }
      @


  module.exports.LessonsPageController = LessonsPageController
