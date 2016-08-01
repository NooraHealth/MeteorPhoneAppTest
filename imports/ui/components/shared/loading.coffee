
{ AppState } = require('../../../api/AppState.coffee')
require './loading.html'

message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p><p class="white-text">Just a moment, your curriculums are loading</p>
  <div class="progress">
    <progress id="progress" value="0" max="100"></div>
  </div>'

spinner = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

Template.Loading.onCreated ->
  console.log "Making a loading template"
  @autorun ->
    percent = AppState.getPercentLoaded()
    progressBar = $("#progress")
    progressBar?.val percent*100

Template.Loading.helpers
  percent: ->
    return AppState.getPercentLoaded()

Template.Loading.onRendered ->
  @loading = window.pleaseWait {
    logo: 'NHlogo.png',
    loadingHtml: message + spinner
  }

Template.Loading.onDestroyed ->
  if @loading
    @loading.finish()

