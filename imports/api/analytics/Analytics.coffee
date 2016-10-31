
##
# Segment.io wrapper to include offline support
##

{ AppConfiguration } = require "../AppConfiguration.coffee"
moment = require 'moment'

class AnalyticsWrapper
  @getOfflineAnalytics: ->
    @analytics ?= new PrivateAnalytics()
    return @analytics

  class PrivateAnalytics
    constructor: ->
      @dict = new PersistentReactiveDict "new_offline_events"

    getOfflineEvents: ->
      events = @dict.get("events")
      console.log "EVENTS in offline events"
      console.log events
      if events
        return JSON.parse(events)
      else
        return []

    clearOfflineEvents: ->
      if not Meteor.status().connected then return
      events = @getOfflineEvents()
      console.log "Going to clear these events"
      console.log events
      clearedEvents = 0
      totalEvents = events.length
      for event in events
        console.log "Clearing offline Event!!"
        console.log event
        clearEvents = ( event )->
          @registerEvent event.type, event.name, event.params
          clearedEvents++
          if clearedEvents == totalEvents
            @dict.setPersistent "events", ""

        Meteor.setTimeout clearEvents.bind(@, event), 100

    registerEvent: ( type, name, params )->
      if not params.Date
        params.date = moment().format("DD/MM/YYYY")
      if not params.userID
        params.userID = AppConfiguration.getCurrentUserId()
      if Meteor.status is undefined or Meteor.status().connected
        console.log "Registering an event!!"
        console.log type
        console.log name
        console.log params
        switch type
          when "IDENTIFY" then analytics.identify name, params
          when "TRACK" then analytics.track name, params
          when "PAGE" then analytics.page name, params
      else
        events = @getOfflineEvents()
        events.push {
          name: name
          type: type
          params: params
        }
        str = JSON.stringify(events)
        console.log "Registered event for later"
        console.log type
        console.log name
        console.log params
        @dict.setPersistent "events", str

Analytics = AnalyticsWrapper.getOfflineAnalytics()

module.exports.Analytics = Analytics
