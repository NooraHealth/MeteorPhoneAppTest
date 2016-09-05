

{ AppConfiguration } = require '../AppConfiguration.coffee'

{ ContentInterface } = require '../content/ContentInterface.coffee'

{ Translator } = require '../utilities/Translator.coffee'

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

{ LessonsPageModel } = require '../models/lessons/LessonsPage.coffee'

{ Award } = require('../../ui/components/lessons/popups/award.coffee')

{ AudioController } = require './Audio.coffee'

{ VideoController } = require './Video.coffee'

{ IntroductionToQuestions } = require('../../ui/components/lessons/popups/introduction_to_questions.coffee')

class LessonsPageController
  ## ------------- PUBLIC METHODS ------------ ##

  onFinishExplanation: (module, lesson, pos, completed, src) ->
    isCurrent = @model.isCurrentModule module
    if isCurrent
      @model.animate "nextButton", true
    @audioController.trackAudioStopped( module, lesson, pos, completed, src )

  onLevelSelected: ( index )->
    @model.startLevel index
    @autoplayMedia()

  onWrongChoice: ( module, choice )->
    @audioController.playAudio(ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO"), 1, true)
    if module.type != "MULTIPLE_CHOICE"
      swal {
        title: ""
        type: "error"
        timer: 3000
        confirmButtonText: Translator.translate "ok", @model.getLanguage()
      }

  onCorrectChoice: ( module, choice )->
    @audioController.playAudio(ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 1, true)
    if module.type != "MULTIPLE_CHOICE"
      swal {
        title: ""
        type: "success"
        timer: 3000
        confirmButtonText: Translator.translate "ok", @model.getLanguage()
      }
    @trackChoice module, choice

  onCompletedQuestion: ( module )->
    @audioController.stopAudio()
    audio = @audioController.playAudio ContentInterface.getSrc(module.correct_audio, "AUDIO"), 1, false, @onFinishExplanation.bind(@, module), @onFinishExplanation.bind(@, module)
    @

  celebrateCompletion: ->
    onConfirm = =>
      if @model.onLastLesson()
        @goToSelectLevelSlide(null, true)
      else
        @model.goToNextLesson()
        @autoplayMedia()

    onCancel = =>
      @goToSelectLevelSlide(null, false)
    
    numLessons = @model.getCurrentLessons().length
    numLessonsCompleted = @model.getLessonIndex() + 1
    if @model.onLastLesson()
      new Award(@language).sendAward( null, null, numLessonsCompleted, numLessons)
      @goToSelectLevelSlide( null, true )
    else
      new Award(@language).sendAward( onConfirm, onCancel, numLessonsCompleted, numLessons )

  onNextButtonClicked: ->
    lessonComplete = @model.onLastModule()
    currentModule = @model.getCurrentModule()
    @audioController.destroyAudio()
    if currentModule.type == "VIDEO"
      @videoController.stopVideo currentModule
    else if @model.onLastModule()
      @celebrateCompletion()
    else
      @model.goToNextModule()
      @autoplayMedia()

  onReplayButtonClicked: ->
    @audioController.replayCurrentAudio()

  onVideoEnd: ->
    if not @model.onLastModule() and not @model.onSelectLevelSlide()
      @showIntroductionToQuestions()
    else
      @celebrateCompletion()
  
  onPageRendered: ->
    @audioController.playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0, true
    
  constructor: ( @curriculum, @language, @condition ) ->
    @audioController = new AudioController()
    @videoController = new VideoController()
    @model = new LessonsPageModel @curriculum, @language, @condition

    ## ------------- PRIVATE METHODS ------------ ##
    @showIntroductionToQuestions = ->
      onConfirm = ()=>
        @model.goToNextModule()
        @autoplayMedia()

      onCancel = ()=>

      new IntroductionToQuestions().send( onConfirm, onCancel, @language )

    @goToSelectLevelSlide = ( event, completedLevel) ->
      lesson = @model.getCurrentLesson()
      module = @model.getCurrentModule()
      @trackGoingToSelectLevel lesson, module, completedLevel
      if completedLevel then @model.goToNextLevel()
      else @model.goToSelectLevelSlide()
      @audioController.destroyAudio()

    @autoplayMedia = ->
      module = @model.getCurrentModule()
      lesson = @model.getCurrentLesson()
      console.log "The current module"
      console.log module
      if module?.type == "VIDEO"
        @videoController.playVideo module
      if module?.hasAudio()
        onFinishAudio = if module.hasExplanation() then @audioController.trackAudioStopped.bind(@, module, lesson) else @onFinishExplanation.bind(@, module, lesson)
        audio = @audioController.playAudio ContentInterface.getSrc(module.audio, "AUDIO"), 1, false, onFinishAudio, onFinishAudio

    @trackGoingToSelectLevel = ( lesson, module, completedLevel )->
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

    @trackChoice = ( module, choice )->
      lesson = @model.getCurrentLesson()
      text = if module?.title then module?.title else module?.question
      analytics.track "Responded to Question", {
        moduleId: module._id
        moduleText: text
        choice: choice
        lessonTitle: lesson.title
        lessonId: lesson._id
        condition: @condition
        language: @language
        type: module.type
      }


  module.exports.LessonsPageController = LessonsPageController
