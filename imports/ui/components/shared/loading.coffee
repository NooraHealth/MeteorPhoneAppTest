
AppState = require('../../../api/AppState.coffee').AppState
require './loading.html'

message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p><p class="white-text">Just a moment, your curriculum is updating </p><p><a onClick="Meteor.logout()">Abort</a></p>
  <div class="progress">
    <progress id="progress" value="0" max="100"></div>
  </div>'

spinner = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

Template.loading.onCreated ->
  @autorun ->
    percent = AppState.get().getPercentLoaded()
    console.log "PERCENT LOADED", percent
    progressBar?.val percent*100

Template.loading.helpers
  percent: ->
    return AppState.get().getPercentLoaded()

Template.loading.onRendered ->
  @loading = window.pleaseWait {
    logo: 'NHlogo.png',
    loadingHtml: message + spinner
  }

Template.loading.onDestroyed ->
  console.log "Destroying the loading page"
  if @loading
    @loading.finish()

