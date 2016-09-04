
{ Translator } = require '../../utilities/Translator.coffee'

{ FooterModel } = require './Footer.coffee'

{ LevelModel } = require './Level.coffee'

{ Curriculums } = require("meteor/noorahealth:mongo-schemas")

{ AppConfiguration } = require '../../AppConfiguration.coffee'


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

    levels = AppConfiguration.getLevels()
    @levels = [
      new LevelModel( @curriculum, levels[0].name, levels[0].image, 0),
      new LevelModel( @curriculum, levels[1].name, levels[1].image, 1),
      new LevelModel( @curriculum, levels[2].name, levels[2].image, 2),
    ]

    home = Translator.translate "home", @language, "UPPER"
    @footer = new FooterModel({
      nextButton: {
        text: ""
        visible: true
        animated: false
      }
      homeButton: {
        text: "<span class='center'>#{home}<i class='fa fa-home'></i></span>"
        visible: true
        animated: false
      }
      replayButton: {
        text: '<span class="center"><i class="fa fa-repeat"></i></span>'
        visible: true
        animated: false
      }
      bar: {
        visible: false
      }
    })

    Tracker.autorun =>
      module = @getCurrentModule()
      if module?.type is "VIDEO"
        @footer.set "replayButton", { "visible": false }
      else
        @footer.set "replayButton", { "visible": true }

    Tracker.autorun =>
      onLastModule = @onLastModule()
      if onLastModule
        text = Translator.translate( "finish", @language, "UPPER")
      else
        text = Translator.translate( "next", @language, "UPPER")
      @footer.set "nextButton", { "text": "<span class='center'>#{text}<i class='fa fa-arrow-right'></i></span>" }

    Tracker.autorun =>
      if @slideIndex() != 0
        @footer.set "bar", { "visible": true }
      else
        @footer.set "bar", { "visible": false }

  slideIndex: ->
    if not @getCurrentLevel().getModuleIndex()?
      return 0
    else
      return @getCurrentLevel().getModuleIndex() + 1

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

  getLessonIndex: ->
    return @getCurrentLevel()?.getLessonIndex()

  getCurrentModules: ->
    return @getCurrentLevel().getCurrentModules()

  getCurrentModule: ->
    return @getCurrentLevel().getCurrentModule()

  isCurrentModule: ( module )->
    return @getCurrentLevel().isCurrentModule module

  isNextModule: ( module )->
    return @getCurrentLevel().isNextModule module

  getModuleIndex: ->
    return @getCurrentLevel()?.getModuleIndex()

  getLanguage: ->
    return @language

  lessonsComplete: ->
    @getCurrentLessons().onLast()

  goToSelectLevelSlide: ->
    @getCurrentLevel().resetSequences()

  onSelectLevelSlide: ->
    return @slideIndex() == 0

  animate: ( button, state )->
    @footer.set button, { animated: state }

module.exports.LessonsPageModel = LessonsPageModel
