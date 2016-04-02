

Curriculums = require('../../api/curriculums/curriculums.coffee').Curriculums

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/layouts/layout.coffee'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'


Template.Home_page.onCreated ->
  @state = new PersistentReactiveDict("Home_page")
  console.log "The state", @state
  @state.setDefaultPersistent {
    curriculumId: ""
    lessonIndex: 0
    hasPlayedIntro: false
    lessons: []
  }

  #@intro = new Audio Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3', "#intro", ""
  @setLessons = =>
    console.log "setting the lessons"
    id = @state.get "curriculumId"
    curriculum = Curriculums?.findOne {_id: id }
    lessons = curriculum?.getLessonDocuments()
    @state.set "lessons", lessons
    console.log lessons

  @currentLessonId = =>
    lessonIndex = @state.get "lessonIndex"
    lessons = @state.get "lessons"
    console.log lessons
    console.log lessonIndex
    return lessons[lessonIndex]._id

  @onLessonCompleted = =>
    lessonIndex = @state.lessonIndex
    @state.set "lessonIndex", ++lessonIndex

  @onCurriculumSelected = ( id )=>
    console.log "Curriculum selected"
    console.trace()
    @state.set "curriculumId", id
    @setLessons()

  #@playAppIntro = =>
    #if not @state.get "hasPlayedIntro" then @intro.playWhenReady()

  @autorun =>
    lessonIndex = @state.get "lessonIndex"
    Session.setPersistent "lessonIndex", lessonIndex
    console.log "AUTORUN: Setting the state #{lessonIndex}"

  @autorun =>
    curriculumId = @state.get "curriculumId"
    Session.setPersistent "curriculumId", curriculumId
    console.log "AUTORUN: Setting the state #{curriculumId}"


Template.Home_page.helpers

  menuArgs: ->
    instance = Template.instance()
    curriculumsToList = Curriculums.find({title:{$ne: "Start a New Curriculum"}})
    return {
      onCurriculumSelected: instance.onCurriculumSelected
      curriculums: curriculumsToList
    }

  thumbnailArgs: (lesson) ->
    instance = Template.instance()
    isCurrentLesson = ( lesson._id == instance.currentLessonId() )
    return {
      lesson: lesson
      onCurriculmSelected: instance.onCurriculmSelected
      isCurrentLesson: isCurrentLesson
    }

  audioArgs: ->
    return {
      src: Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3'
      id: 'intro'
    }

  lessons: ->
    instance = Template.instance()
    return instance.state.get "lessons"
    #curriculumId = instance.state.get "curriculumId"
    #if curriculumId?
      #curriculum = Curriculums?.findOne {_id: curriculumId }
      #return curriculum?.getLessonDocuments()
    #else
      #return []

Template.Home_page.onRendered ->
  #currentLesson = Session.get "current lesson"
  instance = Template.instance()
  #instance.playAppIntro()

  # Scroll to the current lesson
  currentLesson = instance.state.get "currentLesson"
  thumbnail = $(".js-lesson-thumbnail")[currentLesson]
  if currentLesson > 0 and card
    $(card).scrollintoview {
      duration: 2500,
      direction: "vertical"
    }

