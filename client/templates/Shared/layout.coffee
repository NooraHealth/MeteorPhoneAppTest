
Template.layout.helpers
  module: ()->
    return FlowRouter.getParam "_id"

Template.layout.events
  "click #logo": ()->
    FlowRouter.go "/"
