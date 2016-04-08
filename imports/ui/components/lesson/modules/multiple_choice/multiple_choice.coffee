
Modules = require('../../../../../api/modules/modules.coffee').Modules
require "./multiple_choice.html"
require "./option.coffee"

Template.Lesson_view_page_multiple_choice.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    completed: false
    numCorrectResponses: 0
    optionAttributes: {} #map of template data for the module options
    correctlySelected: [] #array of options that have been selected and are correct
    incorrectlySelected: [] #array of options that have been selected but are wrong
  }

  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @getOnSelectedCallback = (module, templateInstance) ->
    return (option) ->
      if module.isCorrectAnswer option
        correctlySelected = templateInstance.state.get "correctlySelected"
        if option not in correctlySelected
          correctlySelected.push option
          templateInstance.state.set "correctlySelected", correctlySelected
          if correctlySelected.length == module.correct_answer.length
            templateInstance.state.set "completed", true
      else
        incorrectlySelected = templateInstance.state.get "incorrectlySelected"
        if option not in incorrectlySelected
          incorrectlySelected.push option
          templateInstance.state.set "incorrectlySelected", incorrectlySelected

  @autorun =>
    instance = @
    module = instance.data.module
    data = instance.data
    map = {}

    getClasses = (option) ->
      correctlySelected = instance.state.get "correctlySelected"
      incorrectlySelected = instance.state.get "incorrectlySelected"
      classes = 'image-choice'
      if option in correctlySelected
        classes += " #{data.correctlySelectedClasses}"
      else if option in incorrectlySelected
        classes += " #{data.incorrectlySelectedClasses}"
        classes += " #{data.incorrectClasses}"
      else if instance.state.get "completed"
        classes += " #{data.incorrectClasses}"
      return classes
    
    mapData = (option, i) ->
      map[option] = {
        src: module.optionSrc(i)
        class: getClasses(option)
      }

    mapData(option, i) for option, i in module.options
    instance.state.set "optionAttributes", map

Template.Lesson_view_page_multiple_choice.helpers
  optionArgs: (option) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    module = instance.data.module
    return {
      attributes: attributes[option]
      onSelected: instance.getOnSelectedCallback module, instance
      option: option
    }

  getOptions: (module, start, end) ->
    return {options: module.options[start...end]}

