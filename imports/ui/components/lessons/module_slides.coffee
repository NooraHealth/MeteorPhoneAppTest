
{ Modules } = require 'meteor/noorahealth:mongo-schemas'

require './module_slides.html'
require './levels/thumbnail.coffee'
require './modules/binary.coffee'
require './modules/scenario.coffee'
require './modules/video.coffee'
require './modules/slide.html'
require './modules/multiple_choice/multiple_choice.coffee'

Template.Module_slides.onCreated ->
  new SimpleSchema({
    modules: { type: Modules._helpers, optional: true }
    language: { type: String }
    "moduleOptions.incorrectClasses": { type: String }
    "moduleOptions.incorrectlySelectedClasses": { type: String }
    "moduleOptions.correctlySelectedClasses": { type: String }
    "moduleOptions.onCorrectChoice": { type: Function }
    "moduleOptions.onWrongChoice": { type: Function }
    "moduleOptions.onCompletedQuestion": { type: Function }
    "moduleOptions.onVideoEnd": { type: Function }
    "moduleOptions.onStopVideo": { type: Function }
    "moduleOptions.isCurrent": { type: Function }
    "moduleOptions.isNext": { type: Function }
    "moduleOptions.onRendered": { type: Function }
  }).validate Template.currentData()

  @autorun =>
    onRendered = Template.currentData().moduleOptions?.onRendered
    numModules = Template.currentData().modules?.length
    Tracker.afterFlush =>
      onRendered numModules

Template.Module_slides.helpers

  getTemplate: ( module )->
    if module?.type == "BINARY"
      return "Lesson_view_page_binary"
    if module?.type == "MULTIPLE_CHOICE"
      return "Lesson_view_page_multiple_choice"
    if module?.type == "SCENARIO"
      return "Lesson_view_page_scenario"
    if module?.type == "VIDEO"
      return "Lesson_view_page_video"
    if module?.type == "SLIDE"
      return "Lesson_view_page_slide"

  shouldRender: ( module, options )->
    return options.isCurrent module# or options.isNext module

  moduleArgs: ( module )->
    instance = Template.instance()
    options = Template.currentData().moduleOptions
    language = Template.currentData().language

    if module.isQuestion()
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        language: language
        incorrectClasses: options.incorrectClasses
        incorrectlySelectedClasses: options.incorrectlySelectedClasses
        correctlySelectedClasses: options.correctlySelectedClasses
        onCorrectChoice: options.onCorrectChoice
        onWrongChoice: options.onWrongChoice
        onCompletedQuestion: options.onCompletedQuestion
      }
    else if module.type == "VIDEO"
      return {
        module: module
        language: language
        onStopVideo: options.onStopVideo
        onVideoEnd: options.onVideoEnd
        isCurrent: options.isCurrent module
      }
    else if module.type == "SLIDE"
      console.log "MAKING A SLIDE"
      return {
        module: module
        language: language
      }

Template.Module_slides.onRendered ->

