
##
# COLLECTIONS
##

require 'meteor/noorahealth:mongo-schemas'

{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'

Meteor.startup ()->
  console.log("The mongourl")
  console.log process.env.MONGO_URL
  console.log Facilities.find().count()
  console.log Conditions.find().count()


