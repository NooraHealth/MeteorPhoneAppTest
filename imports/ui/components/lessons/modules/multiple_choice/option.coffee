
require '../../../../../api/utilities/global_template_helpers.coffee'
require "./option.html"

Template.Lesson_view_page_multiple_choice_option.onCreated ->
  @state = new ReactiveDict()
  @state.setDefault {
    selected: false
  }

  @autorun =>
    new SimpleSchema({
      "attributes.src": {type: String}
      "attributes.class": {type: String}
      "onSelected": {type: Function}
      "option": {type: String}
    }).validate Template.currentData()

Template.Lesson_view_page_multiple_choice_option.events
  "click": (target, template) ->
    data = Template.currentData()
    template.state.set "selected", true
    data.onSelected data.option

