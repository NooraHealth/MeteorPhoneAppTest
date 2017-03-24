
{ curriculums } = require './curriculums.coffee'
{ lessons } = require './lessons.coffee'
{ modules } = require './modules.coffee'

store = {}
store.curriculums = curriculums
store.lessons = lessons
store.modules = modules

module.exports.Store = store
