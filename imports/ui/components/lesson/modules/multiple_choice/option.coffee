
require "./option.html"

Template.Lesson_view_page_multiple_choice_option.onCreated ->
  @state = new ReactiveDict()
  @state.setDefault {
    selected: false
  }

  @autorun =>
    new SimpleSchema({
      "option.option": {type: String}
      "option.src": {type: String}
      "option.i": {type: Number}
      "option.correct": {type: Boolean}
      "onSelected": {type: Function}
      "questionComplete": {type: Boolean}
    }).validate Template.currentData()

  @incorrectlySelected = =>
    correct = Template.currentData().option.correct
    selected = @state.get "selected"
    return selected and not correct

  @correctlySelected = =>
    correct = Template.currentData().option.correct
    selected = @state.get "selected"
    return selected and correct

Template.Lesson_view_page_multiple_choice_option.helpers
  attributes: (option) ->
    instance = Template.instance()

    classes = 'image-choice'
    if instance.correctlySelected()
      classes += ' correctly-selected'
      classes += ' expanded'
    else if instance.incorrectlySelected() or Template.currentData().questionComplete
      classes += ' incorrectly-selected'
      classes += ' faded'
    return {
      id: option.option
      alt: option.i
      src: option.src
      class: classes
    }

Template.Lesson_view_page_multiple_choice_option.events
  "click": (target, template) ->
    data = Template.currentData()
    template.state.set "selected", true
    data.onSelected data.option

