
{ curriculums } = require './curriculums.coffee'
{ lessons } = require './lessons.coffee'
{ modules } = require './modules_mp4_ogg.coffee'

store = {}
store.curriculums = curriculums
store.lessons = lessons
store.modules = modules

module.exports.Store = store
