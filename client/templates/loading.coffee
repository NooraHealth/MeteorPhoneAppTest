

message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p><p><em>Your curriculum is loading</em></p>'
spinner = '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'

Template.loading.onRendered ()->
  if !Session.get "loading splash"
    console.log "In please wait return callback"
    console.log Meteor.pleaseWait
    this.loading = Meteor.pleaseWait {

      logo: 'NHlogo.png',
      loadingHtml: message + spinner
    }
    Session.set 'loading splash', true

Template.loading.onDestroyed ()->
  if this.loading
    this.loading.finish()
