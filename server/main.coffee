
##
# COLLECTIONS
##

require '../imports/api/collections/publications/publications.js'
cloudinary = require("cloudinary")

{ Conditions } = require '../imports/api/collections/schemas/conditions.js'
{ Facilities } = require '../imports/api/collections/schemas/facilities.js'
{ Curriculums } = require '../imports/api/collections/schemas/curriculums/curriculums.js'
{ Modules } = require '../imports/api/collections/schemas/curriculums/modules.js'
{ Lessons } = require '../imports/api/collections/schemas/curriculums/lessons.js'

Meteor.startup ()->
  console.log process.env.MONGO_URL

  cloudinary.config {
    cloud_name: Meteor.settings.public.CLOUDINARY_NAME,
    api_key: Meteor.settings.public.CLOUDINARY_API_KEY,
    api_secret: Meteor.settings.public.CLOUDINARY_API_SECRET
  }
