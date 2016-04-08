
Modules = require('../../../../api/modules/modules.coffee').Modules
require "./binary.html"

Template.Lesson_view_page_binary.onCreated ->
  # Data context validation
  @state = new ReactiveDict()
  @state.setDefault {
    selected: null
    buttonAttributes: {}
  }

  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
    }).validate(Template.currentData())

    @data = Template.currentData()

  @getOnSelected = (instance) ->
    return (event)->
      option = $(event.target).attr "value"
      console.log $(event.target)
      console.log "This was the option that was selected"
      console.log option
      instance.state.set "selected", option
      

  @autorun =>
    instance = @
    module = instance.data.module
    data = instance.data
    map = {}
    selected = instance.state.get "selected"

    getClasses = (option) ->
      classes = 'response button button-fill button-big color-lightblue'
      console.log classes
      if option is selected
        if module.isCorrectAnswer option
          classes += " #{data.correctlySelectedClasses}"
        else
          classes += " #{data.incorrectlySelectedClasses}"
          classes += " #{data.incorrectClasses}"
      else if selected? and module.isCorrectAnswer selected
        classes += " #{data.incorrectClasses}"
      return classes
    
    mapData = (option, i) ->
      console.log "getting the map options", option
      map[option] = {
        class: getClasses(option)
        value: option
      }
    mapData(option, i) for option, i in module.options
    console.log map
    instance.state.set "optionAttributes", map

Template.Lesson_view_page_binary.helpers
  buttonArgs: (option) ->
    instance = Template.instance()
    attributes = instance.state.get "optionAttributes"
    console.log "option" , option
    console.log ":attributes" , attributes
    console.log "attributes[option]" , attributes[option]
    console.log "attributes[yes]" , attributes["Yes"]
    return {
      attributes: attributes[option]
      content: option.toUpperCase()
      onClick: instance.getOnSelected(instance)
    }

