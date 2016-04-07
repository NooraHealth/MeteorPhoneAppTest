
require "./option.html"

Template.Lesson_view_page_multiple_choice_option.onCreated ->
  @state = new ReactiveDict()
  @state.setDefault {
    selected: false
  }

  @autorun =>
    console.log "validating option"
    console.log Template.currentData()
    new SimpleSchema({
      "attributes.src": {type: String}
      "attributes.class": {type: String}
      "onSelected": {type: Function}
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
  #attributes: (option) ->
    #instance = Template.instance()
    #classes = 'image-choice'
    #if instance.correctlySelected()
      #classes += " #{data.correctlySelectedClasses}"
    #else if instance.incorrectlySelected()
      #classes += " #{data.incorrectlySelectedClasses}"
    #else if Template.currentData().questionComplete
      #classes += " #{data.incorrectClasses}"
    #return {
      #id: option.option
      #alt: option.i
      #src: option.src
      #class: classes
    #}

Template.Lesson_view_page_multiple_choice_option.events
  "click": (target, template) ->
    data = Template.currentData()
    template.state.set "selected", true
    data.onSelected data.option

