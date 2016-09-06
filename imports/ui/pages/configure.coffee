
{ AppConfiguration } = require '../../api/AppConfiguration.coffee'

{ Conditions } = require 'meteor/noorahealth:mongo-schemas'

{ Facilities } = require 'meteor/noorahealth:mongo-schemas'

{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'

require './configure.html'

Template.Configure_app_page.onCreated ->
  console.log "Creating a configure page"

  @configureApp = ->
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
      AppConfiguration.setConfiguration {
        hospital: hospital
        condition: condition
      }

      if Meteor.isCordova
        console.log "Going to load"
        FlowRouter.go "load"
      else
        FlowRouter.go "home"

  @autorun =>
    @subscribe "facilities.all"
    @subscribe "conditions.all"

Template.Configure_app_page.helpers
  subscriptionsReady: ()->
    instance = Template.instance()
    return instance.subscriptionsReady()

  hospitals: ->
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
