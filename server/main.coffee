
##
# COLLECTIONS
##

require 'meteor/noorahealth:mongo-schemas'
cloudinary = require("cloudinary")

{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Analytics } = require '../imports/api/analytics/Analytics.coffee'
{ OfflineEvents } = require '../imports/api/collections/offline_events.coffee'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'
{ Modules } = require 'meteor/noorahealth:mongo-schemas'
{ Lessons } = require 'meteor/noorahealth:mongo-schemas'

Meteor.startup ()->

  cloudinary.config {
    cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
    api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
    api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
  }
