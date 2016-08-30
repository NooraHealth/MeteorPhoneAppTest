
{ AppState } = require '../../api/AppState.coffee'
{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'

require './configure.html'

Template.Configure_app_page.onCreated ->
  console.log "Creating a configure page"

  @configureApp = ->
    console.log "Configuring the app!!"
    if not Meteor.status().connected
      swal {
        title: "Oops!"
        text: "You aren't connected to data! Please connect to wifi or data in order to download your curriculums. You can disconnect once your content has downloaded"
      }
    else
      analytics.track "Configured App", {
        condition: condition
        hospital: hospital
      }

      hospital = $("#hospital_select").val()
      condition = $("#condition_select").val()
      AppState.setConfiguration {
        hospital: hospital
        condition: condition
      }

      if Meteor.isCordova
        FlowRouter.go "load"
      else
        console.log "About to go to the language page"
        FlowRouter.go "select_language"

  @autorun =>
    @subscribe "facilities.all"
    @subscribe "conditions.all"

Template.Configure_app_page.helpers
  subscriptionsReady: ()->
    instance = Template.instance()
    return instance.subscriptionsReady()

  hospitals: ->
    console.log("Returning the hospitals")
    console.log Facilities.find().count()
    return Facilities.find({}).fetch()

  conditions: ->
    return Conditions.find({}).fetch()

  buttonArgs: ->
    instance = Template.instance()
    return {
      onClick: instance.configureApp
      content: 'CONFIGURE'
      attributes: {
        id: "configureBtn"
        class: 'full-width link button button-rounded color-blue  button-fill'
      }
    }
