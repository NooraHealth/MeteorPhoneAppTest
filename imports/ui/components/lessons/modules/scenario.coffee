
{ Modules } = require("meteor/noorahealth:mongo-schemas")
{ ContentInterface } = require('../../../../api/content/ContentInterface.coffee')
{ AppState } = require("../../../../api/AppState.coffee")
require '../../../../api/utilities/global_template_helpers.coffee'
require "./scenario.html"
    
Template.Lesson_view_page_scenario.onCreated ->
  # Data context validation
  @autorun =>
    schema = new SimpleSchema({
      module: {type: Modules._helpers}
      language: {type: String}
      correctlySelectedClasses: {type: String}
      incorrectClasses: {type: String}
      incorrectlySelectedClasses: {type: String}
      onWrongChoice: {type: Function}
      onCorrectChoice: {type: Function}
      onCompletedQuestion: {type: Function}
    }).validate(Template.currentData())

    @data = Template.currentData()
    @NORMAL = "Normal"
    @CALLDOC = "CallDoc"
    @EMERGENCY = "Call911"

  #set the state
  @state = new ReactiveDict()
  @state.setDefault {
    selected: []
    complete: false
  }

  @questionComplete = ->
    return @state.get "complete"

  @sharedButtonClasses = "response button-big button button-fill scenario-btn"

  @responseClasses = (option) ->
    selected = @state.get "selected"
    isCorrectAnswer = @data.module.isCorrectAnswer option
    if @questionComplete()
      if isCorrectAnswer
        return @data.correctlySelectedClasses
      else
        return @data.incorrectClasses
    else if option in selected
      return "#{@data.incorrectlySelectedClasses} #{@data.incorrectClasses}"
    else return ""
      
  @getNormalButtonClasses = ->
    classes = "#{@responseClasses(@NORMAL)} #{@sharedButtonClasses} color-green"
    return classes

  @getCallDoctorButtonClasses = ->
    classes = "#{@responseClasses(@CALLDOC)} #{@sharedButtonClasses} color-yellow"
    return classes

  @getEmergencyButtonClasses = ->
    classes = "#{@responseClasses(@EMERGENCY)} #{@sharedButtonClasses} color-red"
    return classes

  @getOnSelected = (instance, module, option) ->
    return (event) ->
      selected = instance.state.get "selected"
      if option not in selected
        selected.push option
        instance.state.set "selected", selected
      if module.isCorrectAnswer option
        instance.state.set "complete", true
        instance.data.onCorrectChoice(option)
        instance.data.onCompletedQuestion()
      else
        instance.data.onWrongChoice(option)

Template.Lesson_view_page_scenario.helpers
  normalButtonArgs: (language, module) ->
    instance = Template.instance()
    translatedNormal = AppState.translate "normal", language, "UPPER"
    return {
      attributes: {
        id: "normalOptionForModule#{module._id}"
        class: instance.getNormalButtonClasses()
      }
      content: '<i class="fa fa-home fa-2x"></i> ' + translatedNormal
      onClick: instance.getOnSelected( instance, module, instance.NORMAL)
    }

  callDoctorButtonArgs: (language, module) ->
    instance = Template.instance()
    translatedCallDoc = AppState.translate "call_doc", language, "UPPER"
    return {
      attributes: {
        id: "calldocOptionForModule#{module._id}"
        class: instance.getCallDoctorButtonClasses()
      }
      content: '<i class="fa fa-phone fa-2x"></i> '  + translatedCallDoc
      onClick: instance.getOnSelected( instance, module, instance.CALLDOC)
    }

  emergencyButtonArgs: (language, module) ->
    instance = Template.instance()
    translatedEmergency = AppState.translate "emergency", language, "UPPER"
    return {
      attributes: {
        id: "emergencyOptionForModule#{module._id}"
        class: instance.getEmergencyButtonClasses()
      }
      content: '<i class="fa fa-ambulance fa-2x"></i> ' + translatedEmergency
      onClick: instance.getOnSelected( instance, module, instance.EMERGENCY)
    }
