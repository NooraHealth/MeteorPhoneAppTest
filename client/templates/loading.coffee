

message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p><p class="white-text">This may take a while, your curriculum is loading</p>'
spinner = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

Template.loading.onRendered ()->
  console.log "In please wait return callback"
  this.loading = Meteor.pleaseWait {
    logo: 'NHlogo.png',
    loadingHtml: message + spinner
  }

Template.loading.onDestroyed ()->
  console.log "Destroying the loading page"
  if this.loading
    this.loading.finish()

