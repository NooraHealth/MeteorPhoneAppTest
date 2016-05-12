
{ ContentInterface } = require('../../api/content/ContentInterface.coffee')
{ ContentDownloader } = require('../../api/cordova/ContentDownloader.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ AppState } = require('../../api/AppState.coffee')

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/components/shared/navbar.html'
require '../../ui/components/home/footer.html'
require '../../ui/components/home/thumbnail.coffee'
require '../../ui/components/home/menu/menu.coffee'
require '../../ui/components/home/menu/list_item.coffee'
require '../../ui/components/audio/audio.coffee'
require '../../ui/components/shared/loading.coffee'

Template.Home_page.onCreated ->
  console.log "Home template created"
  #loads the soundeffects, circumventing a howler.js bug that prevents
  #them from loading in lessons_view.coffee
  new Howl {
    src: ['incorrect_soundeffect.mp3']
  }
  new Howl {
    src: ['correct_soundeffect.mp3']
  }

  @getLessonDocuments = =>
    curriculum = @getCurriculumDoc()
    docs = curriculum?.getLessonDocuments()
    return docs

  @getCurriculumDoc = =>
    id = AppState.get().getCurriculumId()
    return Curriculums?.findOne {_id: id }

  @currentLessonId = =>
    curriculum = @getCurriculumDoc()
    numLessons = if curriculum then curriculum.lessons.length else 0
    if not curriculum? then return 0
    lessonIndex = AppState.get().getLessonIndex()
    if lessonIndex >= numLessons
      lessonIndex = 0
      AppState.get().setLessonIndex lessonIndex
    return curriculum?.lessons?[lessonIndex]

  @onLessonSelected = (id) ->
    FlowRouter.go "lesson", {_id: id}

  @onLanguageSelected = (language) ->
    console.log "In the on language selected"
    AppState.get().setLanguage language
    AppState.get().setLessonIndex 0

  @autorun =>
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"


Template.Home_page.helpers
  curriculumsReady: ->
    instance = Template.instance()
    if Meteor.isCordova
      subscribed = AppState.get().isSubscribed()
      numCurr = Curriculums.find().count()
      alert "Subscripeitons ready? #{subscribed} #{numCurr}"
      return AppState.get().isSubscribed()
    else
      return instance.subscriptionsReady()

  menuArgs: ->
    instance = Template.instance()
    return {
      onLanguageSelected: instance.onLanguageSelected
      languages: ['English', 'Hindi', 'Kannada']
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
    return {
      attributes: {
        src: ContentInterface.get().introPath()
      }
      playing: AppState.get().getShouldPlayIntro()
      whenPaused: setPlayIntroToFalse
      whenFinished: setPlayIntroToFalse
    }

  lessons: ->
    instance = Template.instance()
    return instance.getLessonDocuments()

Template.Home_page.events
  'click #open_side_panel': (e, template) ->
    #hackaround Framework7 bugs on ios where active state is not removed
    console.log("removing the activestate")
    active = template.find(".active-state")
    if active? then $(active).removeClass "active-state"
