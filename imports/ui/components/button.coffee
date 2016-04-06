require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      onClick: {type: Function}
      content: {type: String}
      "attributes.class": {type: String, optional: true}
      "attributes.id": {type: String, optional: true}
      "attributes.name": {type: String, optional: true}
    }).validate(Template.currentData())

Template.Button.events
  'click': (e) ->
    console.log "Button is clicked!!"
    data = Template.currentData()
    data.onClick e


