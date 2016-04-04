
Curriculums = require('../../api/curriculums/curriculums.coffee').Curriculums

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/components/navbar.html'
require '../../ui/components/home/footer.html'
require '../../ui/layouts/layout.coffee'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'

Template.Home_page.onCreated ->
  @state = new PersistentReactiveDict("Home_page")
  @state.setTemporary "hasPlayedIntro", false

  #@intro = new Audio Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3', "#intro", ""
  @getLessonDocuments = =>
    curriculum = @getCurriculumDoc()
    docs = curriculum?.getLessonDocuments()
    return docs

  @getCurriculumDoc = =>
    id = @state.get "curriculumId"
    return Curriculums?.findOne {_id: id }

  @currentLessonId = =>
    curriculum = @getCurriculumDoc()
    lessonIndex = @state.get "lessonIndex"
    return curriculum?.lessons?[lessonIndex]

  @onLessonSelected = (id) =>
    console.log "Lesson selected!"

  @onLessonCompleted = =>
    lessonIndex = @state.get "lessonIndex"
    @state.setPersistent "lessonIndex", ++lessonIndex

  @onCurriculumSelected = ( id )=>
    console.log "Setting the curriculumId"
    console.log id
    @state.setPersistent "curriculumId", id

  #@playAppIntro = =>
    #if not @state.get "hasPlayedIntro" then @intro.playWhenReady()


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
    isCurrentLesson = ( lesson?._id == instance.currentLessonId() )
    return {
      lesson: lesson
      onLessonSelected: instance.onLessonSelected
      isCurrentLesson: isCurrentLesson
    }

  audioArgs: ->
    return {
      src: Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3'
      id: 'intro'
    }

  lessons: ->
    instance = Template.instance()
    return instance.getLessonDocuments()

Template.Home_page.onRendered ->
  instance = Template.instance()
  #instance.playAppIntro()

  # Scroll to the current lesson
  lessonIndex = instance.state.get "lessonIndex"
  thumbnail = $(".js-lesson-thumbnail")[lessonIndex]
  if lessonIndex > 0 and card
    $(card).scrollintoview {
      duration: 2500,
      direction: "vertical"
    }

