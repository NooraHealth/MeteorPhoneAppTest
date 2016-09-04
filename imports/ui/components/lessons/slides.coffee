
{ Modules } = require 'meteor/noorahealth:mongo-schemas'

require './slides.html'
require './module_slides.coffee'
require './levels/thumbnail.coffee'
require './modules/binary.coffee'
require './modules/slide.html'
require './modules/scenario.coffee'
require './modules/video.coffee'
require './modules/multiple_choice/multiple_choice.coffee'

Template.Lesson_view_page_slides.onCreated ->
  new SimpleSchema({
    modules: { type: Modules._helpers, optional: true }
    language: { type: String }
    "levels.$.index": { type: Number }
    "levels.$.name": { type: String }
    "levels.$.image": { type: String }
    "levels.$.isCurrent": { type: Function }
    "moduleOptions.incorrectClasses": { type: String }
    "moduleOptions.incorrectlySelectedClasses": { type: String }
    "moduleOptions.correctlySelectedClasses": { type: String }
    "moduleOptions.onCorrectChoice": { type: Function }
    "moduleOptions.onWrongChoice": { type: Function }
    "moduleOptions.onCompletedQuestion": { type: Function }
    "moduleOptions.onVideoEnd": { type: Function }
    "moduleOptions.onStopVideo": { type: Function }
    "moduleOptions.isCurrent": { type: Function }
    "moduleOptions.onRendered": { type: Function }
    "levelOptions.onLevelSelected": { type: Function }
  }).validate Template.currentData()

Template.Lesson_view_page_slides.helpers

  levelThumbnailArgs: ( level, language, options )->
    model = Template.instance().model
    controller = Template.instance().controller
    return {
      level: {
        index: level.index
        name: level.name
        image: level.image
      }
      onLevelSelected: options.onLevelSelected
      isCurrentLevel: level.isCurrent()
      language: language
    }

Template.Lesson_view_page_slides.onRendered ->
  console.log 'Lesson view page slides rendered'
