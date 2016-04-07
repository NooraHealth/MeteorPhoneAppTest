require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    console.log "validating button"
    console.log Template.currentData()
    new SimpleSchema({
      onClick: {type: Function, optional: true}
      onRendered: {type: Function, optional: true}
      content: {type: String}
      "attributes.class": {type: String, optional: true}
      "attributes.id": {type: String, optional: true}
      "attributes.value": {type: String, optional: true}
      "attributes.name": {type: String, optional: true}
    }).validate(Template.currentData())
    console.log "Donevalidating button"

Template.Button.events
  'click': (e) ->
    data = Template.currentData()
    data.onClick e

Template.Button.onRendered ->
  Template.currentData().onRendered?()


