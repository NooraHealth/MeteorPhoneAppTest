
{ AppConfiguration } = require '../../../../api/AppConfiguration.coffee'
require './progress.html'

Template.Lesson_view_page_footer_progress_bar.onCreated ->
  @autorun =>
    new SimpleSchema({
      "percent": {type: String}
    }).validate Template.currentData()

  @autorun =>
    percent = Template.currentData().percent
    AppConfiguration.getF7().setProgressbar $('.progressbar'), percent
