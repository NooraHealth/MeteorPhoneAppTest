require './load_curriculums.html'
{ AppState } = require '../../api/AppState.coffee'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'

Template.Load_curriculums_page.onCreated ->

  Meteor.subscribe "curriculums.all"
  Meteor.subscribe "lessons.all"
  Meteor.subscribe "modules.all"

  @autorun =>
   if Meteor.isCordova and Meteor.status().connected
    console.log "In the meteor isConnected and cordova in init"
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

  @autorun =>
    console.log "Getting whether subscriptionsReady"
    console.log @subscriptionsReady()
    if @subscriptionsReady()
      configuration = AppState.get().getConfiguration()
      curriculums = Curriculums.find { condition: configuration.condition }
      if not Meteor.status().connected
        AppState.get().setError(new Meteor.Error("Not Connected", "Please connect to data in order to download your curriculum."))
        AppState.get().setConfiguration {}
        FlowRouter.go 'home'
      else
        onComplete = (e) ->
          console.log "SUCCESS LOADING"
          console.log e
          if e
            AppState.get().setError e
          AppState.get().setLanguage 'English'
          AppState.get().setShouldPlayIntro true
          FlowRouter.go "home"
        ContentDownloader.get().loadCurriculums curriculums, onComplete
  
