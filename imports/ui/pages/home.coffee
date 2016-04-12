
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
    AppState.get().setCurriculumId id

  @autorun =>
    id = AppState.get().getCurriculumId()
    @subscribe "curriculums.all"
    @subscribe "lessons.inCurriculum", id

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
    return {
      attributes: {
        src: ContentInterface.get().getUrl 'NooraHealthContent/Audio/AppIntro.mp3'
      }
      playing: AppState.get().shouldPlayIntro()
      whenFinished: -> AppState.get().setShouldPlayIntro false
    }

  lessons: ->
    instance = Template.instance()
    return instance.getLessonDocuments()
