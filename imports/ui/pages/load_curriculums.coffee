
{ AppConfiguration } = require '../../api/AppConfiguration.coffee'
{ Curriculums } = require("../../api/collections/schemas/curriculums/curriculums.js")
{ ContentDownloader } = require('../../api/cordova/ContentDownloader.coffee')

require '../components/shared/loading.coffee'
require './load_curriculums.html'

Template.Load_curriculums_page.onCreated ->

  @firstRun = true

  # @autorun =>
  #   @subscribe "curriculums.all"
  #   @subscribe "lessons.all"
  #   @subscribe "modules.all"

  @autorun =>
    console.log "Getting whether subscriptionsReady"
    if not Meteor.status().connected
      console.log "Meteor status not connected"
      swal {
        title: "Please Connect To Data"
        text: "You need to be connected to wifi or data in order to download your curriculums"
      }

    else if @subscriptionsReady(@) and @firstRun
      @firstRun = false
      configuration = AppConfiguration.getConfiguration()
      curriculums = Curriculums.find { condition: configuration.condition, language: {$in: ["Kannada", "English"] }}
      onComplete = (e) ->
        if e
          console.log "Error downloading curriculum"
          console.log e
          swal {
            title: "Error downloading curriculums"
            text: e.message
          }

        else
          AppConfiguration.setContentDownloaded true
          FlowRouter.go "home"

      ContentDownloader.get().loadCurriculums curriculums, onComplete
