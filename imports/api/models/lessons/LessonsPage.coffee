
{ FooterModel } = require './Footer.coffee'

{ LevelModel } = require './Level.coffee'

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

class LessonsPageModel
  constructor: ( @curriculum, @language, @condition )->
    new SimpleSchema({
      curriculum: { type: Curriculums._helpers }
      language: { type: String }
    }).validate {
      curriculum: @curriculum
      language: @language
    }
    @state = new ReactiveDict()
    @state.set {
      level_index: 0
    }

    @levels = [
      new LevelModel( @curriculum, "beginner", "easy.png", 0),
      new LevelModel( @curriculum, "intermediate", "medium.png", 1),
      new LevelModel( @curriculum, "advanced", "hard.png", 2),
    ]

    home = AppState.translate "home", language, "UPPER"
    @footer = new FooterModel {
      nextButton: {
        text: ""
        visible: true
        animated: false
      }
      homeButton: {
        text:
        visible: true
        animated: false
      }
      replayButton: {
        text: '<span class="center"><i class="fa fa-repeat"></i></span>'
        visible: true
        animated: false
      }
    }

    Tracker.autorun =>
      module = @getCurrentModule()
      if module?.type is "VIDEO"
        @footer.set { replayButton.visible: false }
      else
        @footer.set { replayButton.visible: true }

    Tracker.autorun =>
      onLastModule = @onLastModule()
      if onLastModule
        text = AppState.translate( "finish", @language, "UPPER")
      else
        text = AppState.translate( "next", @language, "UPPER")
      @footer.set { nextButton.text: "<span class='center'>#{text}<i class='fa fa-arrow-right'></i></span>" }

    @slideIndex = ->
      if not @getCurrentLevel()?.currentLessonsSequence()?.getIndex()?
        return 0
      else
        return @getCurrentLevel().currentLessonsSequence().getIndex() + 1

  set: (option) ->
    @state.set option

  getLevels: ->
    return @levels

  getLevelIndex: ->
    return @state.get "level_index"

  startLevel: ( index )->
    @set { level_index: index }
    @goToNextLesson()

  isCurrentLevel: (level) ->
    return @getCurrentLevel().isEqual level

  goToNextLevel: ->
    index = @getLevelIndex()
    if index == @levelModels.length - 1
      @set { level_index: 0 }
    else
      @set { level_index: ++index }

  goToNextLesson: ->
    @animate "nextButton", false
    @getCurrentLevel().goToNextLesson()

  goToNextModule: ->
    @animate "nextButton", false
    @getCurrentLevel().goToNextModule()

  onLastModule: ->
    @getCurrentLevel().onLastModule()

  onLastLesson: ->
    @getCurrentLevel().onLastLesson()

  getCurrentLevel: ->
    return @getLevels()[@getLevelIndex()]

  getCurrentLesson: ->
    return @getCurrentLevel().getCurrentLesson()

  getCurrentLessons: ->
    return @getCurrentLevel().getLessons()

  getNumLessonsCompleted: ->
    return @getCurrentLevel()?.getNumLessonsCompleted()

  getCurrentModules: ->
    return @getCurrentLevel().currentModulesSequence()

  getCurrentModule: ->
    return @getCurrentLevel().getCurrentModule()

  isCurrentModule: ( module )->
    return @getCurrentLevel().isCurrentModule module

  isNextModule: ( module )->
    return @getCurrentLevel().isNextModule module

  getNumModulesCompleted: ->
    return @getCurrentLevel()?.getNumModulesCompleted()

  getLanguage: ->
    return @language

  onSelectLevelSlide: ->
    return @slideIndex() == 0

  animate: ( button, state )->
    @footer.set { "#{button}.animated", state }

module.exports.LessonsPageModel = LessonsPageModel
