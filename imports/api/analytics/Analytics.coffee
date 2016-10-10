
##
# Segment.io wrapper to include offline support
##

{ OfflineEvents } = require '../collections/offline_events.coffee'

class Analytics

  @registerEvent: ( type, name, params )->
    console.log Meteor.status?().connected
    console.log Meteor.status?
    if Meteor.status is undefined or Meteor.status().connected
      console.log "Analytics registering an event"
      switch type
        when "IDENTIFY" then analytics.identify name, params
        when "TRACK" then analytics.track name, params
        when "PAGE" then analytics.page name, params
    else
      console.log "Analytics inserting an event for later"
      console.log "PARAMs"
      console.log params
      OfflineEvents.insert { type: type, name: name, params: JSON.stringify(params) }

if Meteor.isClient

  Meteor.startup ()->
    console.log "Creating a new worker"
    # worker = new Worker('./clear_offline_events_worker.js')
    # console.log worker
    # worker.postMessage( "something" )
    #
    clearOfflineEvents = ->
      console.log "About to clear the offline events"
      events = OfflineEvents.find({}).fetch()
      console.log events
      for event in events
        Analytics.registerEvent event.type, event.name, JSON.parse(event.params)
        deleteEvent = ( _id )->
          console.log "Removing the event"
          OfflineEvents.remove { _id: event._id }
        #set timeout to put this on the bottom of the render loop
        Meteor.setTimeout( deleteEvent.bind(this, event._id), 10 )

    clearOfflineEvents()
    #
    # Meteor.setInterval clearOfflineEvents, 10000

module.exports.Analytics = Analytics
