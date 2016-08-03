
{ ContentInterface } = require('../../api/content/ContentInterface.coffee')
{ ContentDownloader } = require('../../api/cordova/ContentDownloader.coffee')
{ Curriculums } = require("meteor/noorahealth:mongo-schemas")
{ Lessons } = require("meteor/noorahealth:mongo-schemas")
{ AppState } = require('../../api/AppState.coffee')

# TEMPLATE
require './home.html'

# COMPONENTS
require '../../ui/components/shared/navbar.html'
require '../../ui/components/home/footer.html'
require '../../ui/components/home/thumbnail.coffee'

Template.Home_page.onCreated ->
  console.log "Rendering home page"

  @onLevelSelected = ( levelName ) ->
    lessons = AppState.getLessons levelName
    if lessons.length > 0
      FlowRouter.go "level", { level: levelName }
    else
      swal {
        title: "Oops!"
        text: "We don't have lessons available for that level yet"
      }

  @autorun =>
   if Meteor.isCordova and Meteor.status().connected
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

Template.Home_page.helpers

  getLanguage: ->
    return AppState.getLanguage()

  curriculumsReady: ->
    instance = Template.instance()
    return instance.subscriptionsReady()

  thumbnailArgs: (level ) ->
    console.log Curriculums.find({}).count()
    console.log "Curriculum get lesson docs"
    curr = Curriculums.findOne()
    console.log curr
    curr.getLessonDocuments()

    instance = Template.instance()
    isCurrentLevel = ( AppState.getLevel() == level.name )
    return {
      level: level
      onLevelSelected: instance.onLevelSelected
      isCurrentLevel: isCurrentLevel
      language: AppState.getLanguage()
    }

  levels: ->
    return AppState.getLevels()

Template.Home_page.events
  'click #open_side_panel': (e, template) ->
    #hackaround Framework7 bugs on ios where active state is not removed
    active = template.find(".active-state")
    if active? then $(active).removeClass "active-state"
