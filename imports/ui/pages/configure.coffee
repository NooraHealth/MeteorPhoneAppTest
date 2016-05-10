
require './configure.html'

Template.Configure_app_page.onCreated ->
  configureApp: ->
    console.log "Configuring the app!!"

Template.Configure_app_page.helpers
  hospitals: ->
    return [
      {name: 'Jayadeva'},
      {name: 'Manipal Bangalore'}
    ]

  conditions: ->
    return [
      {name: 'Diabetes'},
      {name: 'Cardiac Surgery'},
      {name: 'Neonatology'}
    ]

  buttonArgs: ->
    instance = Template.instance()
    return {
      onClick: instance.configureApp
      content: 'Configure'
    }
