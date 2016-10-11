
##
# Segment.io wrapper to include offline support
##

moment = require 'moment'

class AnalyticsWrapper
  @getOfflineAnalytics: ->
    @analytics ?= new PrivateAnalytics()
    return @analytics

  class PrivateAnalytics
    constructor: ->
      @dict = new PersistentReactiveDict "offline_events"
      @dict.setPersistent "events", ""

    getOfflineEvents: ->
      events = @dict.get("events")
      if events
        return JSON.parse(events)
      else
        return []

    clearOfflineEvents: ->
      if not Meteor.status().connected then return
      events = @getOfflineEvents()
      clearedEvents = 0
      totalEvents = events.length
      for event in events
        clearEvents = ( event )->
          @registerEvent event.type, event.name, event.params
          clearedEvents++
          if clearedEvents == totalEvents
            @dict.setPersistent "events", ""

        Meteor.setTimeout clearEvents.bind(@, event), 100

    registerEvent: ( type, name, params )->
      if not params.Date
        params.Date = moment().format("DD/MM/YYYY")
        console.log params
      if Meteor.status is undefined or Meteor.status().connected
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
        @dict.setPersistent "events", str

Analytics = AnalyticsWrapper.getOfflineAnalytics()

module.exports.Analytics = Analytics
