Curriculums = new Mongo.Collection("nh_home_pages")
Modules = new Mongo.Collection("nh_modules")
Lessons = new Mongo.Collection("nh_lessons")

Ground.Collection Curriculums
Ground.Collection Modules
Ground.Collection Lessons

module.exports.Lessons = Lessons
module.exports.Curriculums = Curriculums
module.exports.Modules = Modules

#require './lessons/helpers.coffee'
#require './lessons/schema.coffee'
#require './modules/helpers.coffee'
#require './modules/schema.coffee'
#require './curriculums/helpers.coffee'
#require './curriculums/schema.coffee'

