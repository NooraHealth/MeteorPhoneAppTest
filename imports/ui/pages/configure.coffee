
{ AppState } = require '../../api/AppState.coffee'
require './configure.html'

Template.Configure_app_page.onCreated ->
  @configureApp = ->
    console.log "Configuring the app!!"
    hospital = $("#hospital_select").val()
    condition = $("#condition_select").val()
    AppState.get().setConfiguration {
      hospital: hospital
      condition: condition
    }

    FlowRouter.go "load"

Template.Configure_app_page.helpers
  hospitals: ->
    return [
      {name: 'Jayadeva'},
      {name: 'Manipal Bangalore'}
    ]

  conditions: ->
    return [
      {name: 'Cardiac Surgery'},
      {name: 'Neonatology'}
    ]

  buttonArgs: ->
    instance = Template.instance()
    console.log "Configure app"
    console.log instance.configureApp
    return {
      onClick: instance.configureApp
      content: 'CONFIGURE'
      attributes: {
        class: 'full-width link button button-rounded color-blue  button-fill'
      }
    }
