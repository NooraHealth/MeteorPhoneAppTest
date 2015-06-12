
message = '<p class="loading-message">'+"Welcome to Noora Health"+'</p>'
spinner = '<div class="sk-spinner sk-spinner-rotating-plane"></div>'

Template.loading.onRendered ()->
  if !Session.get "loading splash"
    this.loading = window.pleaseWait {
      logo: 'NHlogo.png',
      backgroundColor: '#03A9F4',
      loadingHtml: message + spinner
    }
    Session.set 'loading splash', true

Template.loading.onDestroyed ()->
  if this.loading
    this.loading.finish()
