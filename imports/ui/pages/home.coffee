

Curriculums = require('../../api/curriculums/curriculums.coffee').Curriculums

Template.Home_page.onCreated ->
  console.log "In home page", Curriculums.find({}).fetch()
  @state = new ReactiveDict()
  @state.setDefault {
    curriculumId: ""
    lessonIndex: 0
    hasPlayedIntro: false
  }

  @state.set "curriculumId", Session.get "curriculumId"
  @state.set "lessonIndex", Session.get "lessonIndex"

  #@intro = new Audio Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3', "#intro", ""

  @onLessonCompleted = =>
    lessonIndex = @state.lessonIndex
    @state.set "lessonIndex", ++lessonIndex

  @onCurriculumSelected = ( id )=>
    console.log "Curriculum selected"
    console.trace()
    @state.set "curriculumId", id

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
    console.log "getting the menu args!"
    instance = Template.instance()
    console.log instance.onCurriculmSelected
    curriculumsToList = Curriculums.find({title:{$ne: "Start a New Curriculum"}})
    return {
      onCurriculumSelected: instance.onCurriculumSelected
      curriculums: curriculumsToList
    }

  thumbnailArgs: (lesson) ->
    console.log "GEtting the thumbnail args"
    instance = Template.instance()
    return {
      lesson: lesson
      onCurriculmSelected: instance.onCurriculmSelected
    }

  audioArgs: ->
    return {
      src: Meteor.getContentSrc() + 'NooraHealthContent/Audio/AppIntro.mp3'
      id: 'intro'
    }

  lessons: ->
    console.log "Retrieving lessons"
    instance = Template.instance()
    curriculumId = instance.state.get "curriculumId"
    if curriculumId?
      curriculum = Curriculums?.findOne {_id: curriculumId }
      return curriculum?.getLessonDocuments()
    else
      return []

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

