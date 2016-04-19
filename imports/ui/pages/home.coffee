
ContentInterface = require('../../api/content/ContentInterface.coffee').ContentInterface

Curriculums = require('../../api/curriculums/curriculums.coffee').Curriculums

AppState = require('../../api/AppState.coffee').AppState

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/components/navbar.html'
require '../../ui/components/home/footer.html'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'

Template.Home_page.onCreated ->
  console.log "Going to the home page"
  @getLessonDocuments = =>
    curriculum = @getCurriculumDoc()
    docs = curriculum?.getLessonDocuments()
    return docs

  @getCurriculumDoc = =>
    id = AppState.get().getCurriculumId()
    return Curriculums?.findOne {_id: id }

  @currentLessonId = =>
    curriculum = @getCurriculumDoc()
    lessonIndex = AppState.get().getLessonIndex()
    return curriculum?.lessons?[lessonIndex]

  @onLessonSelected = (id) ->
    FlowRouter.go "lesson", {_id: id}

  @onCurriculumSelected = ( id ) ->
    console.log "CURRICUKU<M SELECTED"
    AppState.get().setCurriculumId id
    if Meteor.isCordova
      FlowRouter.go 'loading'
      #download curriculum
      ContentInterface.downloadCurriculum id

  @autorun =>
    id = AppState.get().getCurriculumId()
    @subscribe "curriculums.all"
    @subscribe "lessons.inCurriculum", id

  console.log "End of home page"

Template.Home_page.helpers
  curriculumsReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady()

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
    instance = Template.instance()
    setPlayIntroToFalse = -> AppState.get().setShouldPlayIntro false
    console.log ContentInterface.get().introAudio()
    return {
      attributes: {
        src: ContentInterface.get().introAudio()
      }
      playing: AppState.get().shouldPlayIntro()
      whenPaused: setPlayIntroToFalse
      whenFinished: setPlayIntroToFalse
    }

  lessons: ->
    instance = Template.instance()
    return instance.getLessonDocuments()
