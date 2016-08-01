
{ AppState } = require '../../../../api/AppState.coffee'
require './progress.html'

Template.Lesson_view_page_footer_progress_bar.onCreated ->
  @autorun =>
    new SimpleSchema({
      "percent": {type: String}
    }).validate Template.currentData()

  @autorun =>
    console.log "Setting the progress"
    percent = Template.currentData().percent
    console.log percent
    AppState.getF7().setProgressbar $('.progressbar'), percent

