
##
# COLLECTIONS
##

require 'meteor/noorahealth:mongo-schemas'

{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'
{ Modules } = require 'meteor/noorahealth:mongo-schemas'
{ Lessons } = require 'meteor/noorahealth:mongo-schemas'

Meteor.startup ()->
  console.log("The mongourl")
  console.log process.env.MONGO_URL

