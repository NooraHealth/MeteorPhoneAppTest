require './lesson_view.html'

Template.Lesson_view_page.helpers
  modules: ()->
    _id = FlowRouter.getParam "_id"
    lesson = Lessons.findOne { _id: _id }
    return lesson.getModulesSequence()

  getTemplate: ( context )->
    module = Template.currentData()
    if module.type == "BINARY"
      template = "binaryChoiceModule"
    if module.type == "MULTIPLE_CHOICE"
      template = "multipleChoiceModule"
    if module.type == "SCENARIO"
      template = "scenarioModule"
    if module.type == "VIDEO"
      template = "videoModule"
    if module.type == "SLIDE"
      template = "slideModule"

    return template

Template.Lesson_view_page.onRendered ()->
  mySwiper = App.swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      nextButton: '.swiper-button-next',
  }
