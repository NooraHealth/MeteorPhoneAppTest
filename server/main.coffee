
##
# COLLECTIONS
##

require 'meteor/noorahealth:mongo-schemas'
cloudinary = require("cloudinary")

{ Conditions } = require 'meteor/noorahealth:mongo-schemas'
{ Facilities } = require 'meteor/noorahealth:mongo-schemas'
{ Curriculums } = require 'meteor/noorahealth:mongo-schemas'
{ Modules } = require 'meteor/noorahealth:mongo-schemas'
{ Lessons } = require 'meteor/noorahealth:mongo-schemas'

Meteor.startup ()->
  console.log("The mongourl")
  console.log process.env.MONGO_URL

  cloudinary.config {
    cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
    api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
    api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
  }
  

