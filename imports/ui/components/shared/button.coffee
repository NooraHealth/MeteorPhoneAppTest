require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      onClick: {type: Function, optional: true}
      onRendered: {type: Function, optional: true}
      content: {type: String}
      "attributes.id": {type: String}
      "attributes.class": {type: String, optional: true}
      "attributes.value": {type: String, optional: true}
      "attributes.name": {type: String, optional: true}
    }).validate(Template.currentData())


  @removeActiveState = ->
    active = @find(".active-state")
    if active?
      $(active).removeClass "active-state"

  @onClick = (e, data) =>
    data.onClick e
    @removeActiveState()

    analytics.track "Pressed Button", {
      id: data.attributes.id
    }

Template.Button.events
  'touchend': (e) ->
    instance = Template.instance()
    instance.onClick e, Template.currentData()

  'click': (e) ->
    instance = Template.instance()
    instance.onClick e, Template.currentData()

Template.Button.onRendered ->
  Template.currentData().onRendered?()


