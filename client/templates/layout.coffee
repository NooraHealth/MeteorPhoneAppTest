Template.layout.helpers {
  getTransition: ()->
    console.log "returning the transition"
    console.log Session.get "current transition"
    return Session.get "current transition"
}
