

message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p><p class="white-text">This may take a while, your curriculum is loading</p><p><a onClick="Meteor.logout()">Abort</a></p>
  <div class="progress">
    <div id="progress" class="determinate" style="{{percent}}"></div>
  </div>'

spinner = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

Template.loading.helpers
  percent: ()->
    return Session.get "percent loaded"

Template.loading.onRendered ()->
  this.loading = Meteor.pleaseWait {
    logo: 'NHlogo.png',
    loadingHtml: message + spinner
  }
  this.autorun ()->
    percent = Session.get "percent loaded"
    $("#progress").css("width", percent*100+"%")


Template.loading.onDestroyed ()->
  if this.loading
    this.loading.finish()

