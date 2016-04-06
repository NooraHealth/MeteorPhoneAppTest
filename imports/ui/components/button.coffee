require './button.html'

Template.Button.onCreated ->
  #data context validation
  @autorun =>
    new SimpleSchema({
      onClick: {type: Function}
      content: {type: String}
      classes: {type: String}
    }).validate(Template.currentData())

Template.Button.events
  'click': (e) ->
    instance = Template.instance()
    instance.state.onClick e


