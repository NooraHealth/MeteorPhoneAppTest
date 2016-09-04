

{ AppConfiguration } = require '../AppConfiguration.coffee'

{ ContentInterface } = require '../content/ContentInterface.coffee'

{ Translator } = require '../utilities/Translator.coffee'

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

{ LessonsPageModel } = require '../models/lessons/LessonsPage.coffee'

{ Award } = require('../../ui/components/lessons/popups/award.coffee')

{ Audio } = require('../../ui/components/shared/audio.coffee')

{ AudioController } = require './Audio.coffee'

{ VideoController } = require './Video.coffee'

{ IntroductionToQuestions } = require('../../ui/components/lessons/popups/introduction_to_questions.coffee')

class LessonsPageController
  ## ------------- PUBLIC METHODS ------------ ##

  onFinishExplanation: (module, pos, completed, src) ->
    isCurrent = @model.isCurrentModule module
    if isCurrent
      @model.animate "nextButton", true
    @trackAudioStopped( pos, completed, src )

  onLevelSelected: ( index )->
    @model.startLevel index
    @autoplayMedia()
    #@model.goToNextLesson()
    #lessons = @model.getCurrentLessons()
    #if lessons.length > 0
    #else
      #swal {
        #title: "Oops!"
        #text: "We don't have lessons available for that level yet"
      #}

  onWrongChoice: ( module, choice )->
    @playAudio(ContentInterface.getSrc(ContentInterface.incorrectSoundEffectFilename(), "AUDIO"), 1)
    console.log "in on Wrong chceoi"
    if module.type != "MULTIPLE_CHOICE"
      console.log "CHOICE!!"
      console.log "making a swal"
      swal {
        title: ""
        type: "error"
        timer: 3000
        confirmButtonText: Translator.translate "ok", @model.getLanguage()
      }

  onCorrectChoice: ( module, choice )->
    @playAudio(ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 1)
    if module.type != "MULTIPLE_CHOICE"
      swal {
        title: ""
        type: "success"
        timer: 3000
        confirmButtonText: Translator.translate "ok", @model.getLanguage()
      }
    @trackChoice module, choice

  onCompletedQuestion: ( module )->
    @stopAudio()
    audio = @playAudio ContentInterface.getSrc(module.correct_audio, "AUDIO"), 1, @onFinishExplanation.bind(@, module), @onFinishExplanation.bind(@, module)
    @setCurrentAudio audio
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
    @destroyAudio()
    if currentModule.type == "VIDEO"
      @stopVideo currentModule
    else if @model.onLastModule()
      @celebrateCompletion()
    else
      @model.goToNextModule()
      @autoplayMedia()

  onReplayButtonClicked: ->
    @getCurrentAudio().replay()

  onVideoEnd: ->
    if not @model.onLastModule() and not @model.onSelectLevelSlide()
      @showIntroductionToQuestions()
  
  onPageRendered: ->
    @playAudio ContentInterface.getSrc(ContentInterface.correctSoundEffectFilename(), "AUDIO"), 0 
    
  constructor: ( @curriculum, @language, @condition ) ->
    @model = new LessonsPageModel @curriculum, @language, @condition
    @liveAudio = []

    ## ------------- PRIVATE METHODS ------------ ##
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
      console.log $("#" + module._id)
      console.log $("#" + module._id).find("video")
      $("#" + module._id).find("video")[0]?.play()

    @goToSelectLevelSlide = ( event, completedLevel) ->
      lesson = @model.getCurrentLesson()
      module = @model.getCurrentModule()
      @trackGoingToSelectLevel lesson, module, completedLevel
      if completedLevel then @model.goToNextLevel()
      else @model.goToSelectLevelSlide()
      @destroyAudio()

    @autoplayMedia = ->
      module = @model.getCurrentModule()
      if module.type == "VIDEO"
        console.log "About to play the video"
        @playVideo module
      if module.hasAudio()
        onFinishAudio = if module.hasExplanation() then @trackAudioStopped.bind(@) else @onFinishExplanation.bind(@, module)
        audio = @playAudio ContentInterface.getSrc(module.audio, "AUDIO"), 1, onFinishAudio, onFinishAudio
        @setCurrentAudio audio

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

    @trackAudioStopped = (pos, completed, src) ->
      lesson = @model.getCurrentLesson()
      module = @model.getCurrentModule()
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
