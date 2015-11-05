Meteor.startup ()->
  console.log "Creating app"
  this.App = new Framework7(
    router:false
  )
