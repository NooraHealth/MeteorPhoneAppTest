
###
# Educator
###

OfflineEvents = new Ground.Collection "offline_events"

OfflineEventsSchema = new SimpleSchema
  name:
    type: String
    max: 100
  type:
    type: String
    regEx: /^(IDENTIFY|PAGE|TRACK)$/
  params:
    type: String

OfflineEvents.allow({
  insert: ( userId, doc )->
    #validation done through the schema
    return true
    
  remove: ( userId, doc )->
    if Meteor.isServer
      return true
})
OfflineEvents.attachSchema OfflineEventsSchema

module.exports.OfflineEvents = OfflineEvents
