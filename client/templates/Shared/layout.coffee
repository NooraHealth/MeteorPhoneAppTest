
Template.layout.helpers
  module: ()->
    console.log FlowRouter.getParam "_id"
    console.log "Fetting module"
    return FlowRouter.getParam "_id"

Template.layout.events
  "click #logo": ()->
    FlowRouter.go "/"
