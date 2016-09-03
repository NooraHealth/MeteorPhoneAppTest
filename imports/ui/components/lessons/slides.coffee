
Template.Lesson_view_page_slides.onCreated ()->
  new SimpleSchema({
    modules: { type: Modules._helpers }
    onRendered: { type: Function }
    language: { type: String }
    "levels.index": { type: Number }
    "levels.name": { type: String }
    "levels.image": { type: String }
    "moduleOptions.incorrectClasses": { type: String }
    "moduleOptions.incorrectlySelectedClasses": { type: String }
    "moduleOptions.correctlySelectedClasses": { type: String }
    "moduleOptions.onCorrectChoice": { type: Function }
    "moduleOptions.onWrongChoice": { type: Function }
    "moduleOptions.onCompletedQuestion": { type: Function }
    "moduleOptions.onVideoEnd": { type: Function }
    "moduleOptions.onStopVideo": { type: Function }
    "moduleOptions.isCurrent": { type: Function }
    "levelOptions.isCurrent": { type: Function }
    "levelOptions.onLevelSelected": { type: Function }
  }).validate

Template.Lesson_view_page_slides.helpers

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

  moduleArgs: ( module, language, options )->
    instance = Template.instance()

    if module.isQuestion()
      showAlert = if module.type == 'MULTIPLE_CHOICE' then false else true
      return {
        module: module
        language: language
        incorrectClasses: options.incorrectClasses
        incorrectlySelectedClasses: options.incorrectlySelectedClasses
        correctlySelectedClasses: options.correctlySelectedClasses
        onCorrectChoice: options.onChoice
        onWrongChoice: options.onChoice
        onCompletedQuestion: options.onCompletedQuestion
      }
    else if module.type == "VIDEO"
      return {
        module: module
        language: language
        incorrectClasses: options.incorrectClasses
        onStopVideo: options.onStopVideo
        onVideoEnd: options.onVideoEnd
        isCurrent: options.isCurrent module
      }
    else if module.type == "SLIDE"
      return {
        module: module
        language: language
      }

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
      isCurrentLevel: options.isCurrent level
      language: language
    }


Template.Lesson_view_page_slides.onRendered ->
  Template.currentData()?.onRendered()?

