
Lessons = require('../../api/lessons/lessons.coffee').Lessons

require './lesson_view.html'
require '../components/lesson/modules/binary.coffee'
require '../components/lesson/modules/scenario.coffee'
require '../components/lesson/modules/multiple_choice.coffee'
require '../components/lesson/modules/slide.html'
require '../components/lesson/modules/video.coffee'

Template.Lesson_view_page.onCreated ()->
  @state = new ReactiveDict()
  @state.setDefault {
    moduleIndex: 0
  }

  @getLesson = ()=>
    id = FlowRouter.getParam "_id"
    lesson = Lessons.findOne { _id: id }
    return lesson

  @onClickNext = ()=>
    index = @state.get "moduleIndex"
    @state.set "moduleIndex", ++index

Template.Lesson_view_page.helpers
  lessonTitle: ()->
    instance = Template.instance()
    return instance.getLesson().title

  moduleArgs: (module) ->
    return { module: module }

  modules: ->
    lesson = Template.instance().getLesson()
    return lesson.getModulesSequence()

  getTemplate: (module) ->
    console.log "getting the template"
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

Template.Lesson_view_page.onRendered ()->
  mySwiper = App.swiper '.swiper-container', {
      lazyLoading: true,
      preloadImages: false,
      nextButton: '.swiper-button-next',
  }
