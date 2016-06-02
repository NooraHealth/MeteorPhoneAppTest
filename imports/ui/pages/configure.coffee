
{ AppState } = require '../../api/AppState.coffee'
{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'

require './configure.html'

Template.Configure_app_page.onCreated ->
  @configureApp = ->
    console.log "Configuring the app!!"
    analytics.track "Configured App", {
      condition: condition
      hospital: hospital
    }

    hospital = $("#hospital_select").val()
    condition = $("#condition_select").val()
    AppState.get().setConfiguration {
      hospital: hospital
      condition: condition
    }

    FlowRouter.go "load"

  @autorun =>
    @subscribe "facilities.all"
    @subscribe "conditions.all"

  @autorun =>
    console.log @subscriptionsReady()
 
Template.Configure_app_page.helpers
  subscriptionsReady: ()->
    console.log "in the subscriptionsReady"
    instance = Template.instance()
    return instance.subscriptionsReady()

  hospitals: ->
    return Facilities.find({}).fetch()

  conditions: ->
    return Conditions.find({}).fetch()

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
