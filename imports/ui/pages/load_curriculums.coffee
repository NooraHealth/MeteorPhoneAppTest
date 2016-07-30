require './load_curriculums.html'
{ AppState } = require '../../api/AppState.coffee'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'
{ ContentInterface } = require('../../api/content/ContentInterface.coffee')

Template.Load_curriculums_page.onCreated ->

  @firstRun = true
  @autorun =>
   if Meteor.isCordova and Meteor.status().connected
    console.log "In the meteor isConnected and cordova in init"
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

  @autorun =>
    console.log "Getting whether subscriptionsReady"
    if ContentInterface.subscriptionsReady(@) and @firstRun
      @firstRun = false
      configuration = AppState.getConfiguration()
      curriculums = Curriculums.find { condition: configuration.condition }
      if not Meteor.status().connected
        AppState.setError(new Meteor.Error("Not Connected", "Please connect to data in order to download your curriculum."))
      else
        onComplete = (e) ->
          console.log "SUCCESS LOADING"
          console.log e
          if e
            AppState.setError e
          FlowRouter.go "select_language"
          #diconnect from the server to freeze the app at its current state
          if Meteor.settings.public.METEOR_ENV == "production"
            Meteor.disconnect()

        ContentDownloader.get().loadCurriculums curriculums, onComplete
  
