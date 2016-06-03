require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      onClick: {type: Function, optional: true}
      onRendered: {type: Function, optional: true}
      content: {type: String}
      "attributes.class": {type: String, optional: true}
      "attributes.id": {type: String, optional: true}
      "attributes.value": {type: String, optional: true}
      "attributes.name": {type: String, optional: true}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @removeActiveState = ->
    active = @find(".active-state")
    if active?
      $(active).removeClass "active-state"

Template.Button.events
  'touchend': (e) ->
    instance = Template.instance()
    data = Template.currentData()
    data.onClick e
    instance.removeActiveState()

    analytics.track "Pressed Button", {
      content: instance.data.content
    }

Template.Button.onRendered ->
  Template.currentData().onRendered?()


