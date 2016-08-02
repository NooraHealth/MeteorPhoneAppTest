{ AppState } = require '../../api/AppState.coffee'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'
{ ContentInterface } = require('../../api/content/ContentInterface.coffee')

require '../components/shared/loading.coffee'
require './load_curriculums.html'

Template.Load_curriculums_page.onCreated ->

  @firstRun = true
  @autorun =>
    @subscribe "curriculums.all"
    @subscribe "lessons.all"
    @subscribe "modules.all"

  @autorun =>
    console.log "Getting whether subscriptionsReady"
    if not Meteor.status().connected
      console.log "Meteor status not connected"
      AppState.setError(new Meteor.Error("Not Connected", "Please connect to data in order to download your curriculum."))
    else if ContentInterface.subscriptionsReady(@) and @firstRun
      console.log "About to download"
      @firstRun = false
      configuration = AppState.getConfiguration()
      curriculums = Curriculums.find { condition: configuration.condition }
      onComplete = (e) ->
        console.log "SUCCESS LOADING"
        console.log e
        if e
          AppState.setError e
        AppState.setContentDownloaded true
        FlowRouter.go "select_language"

      ContentDownloader.get().loadCurriculums curriculums, onComplete
  
