
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface }= require('../../api/content/ContentInterface.coffee')
{ AppState }= require('../../api/AppState.coffee')
{ TAPi18n } = require("meteor/tap:i18n")

require '../components/lesson/modules/video.coffee'

Template.Introduction_video_page.onCreated ()->

  @state = new ReactiveDict()
  @state.setDefault {
  }


Template.Introduction_video_page.helpers

