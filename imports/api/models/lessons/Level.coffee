
{ Curriculums } = require "meteor/noorahealth:mongo-schemas"
{ Sequence } = require "./base/Sequence.coffee"

class LevelModel

  constructor: (@curriculum, @name, @image, @index) ->
    
    # Validate the arguments
    new SimpleSchema({
      curriculum: {type: Curriculums._helpers}
      name: {type: String}
      image: {type: String}
    }).validate {
      curriculum: @curriculum
      name: @name
      image: @image
    }

    @lessons = @curriculum.getLessonDocuments( @name )
    docsAreEqual = (first, second) ->
      return first?._id is second?._id

    sequence = @lessons.map (lesson) =>
      modulesSequence = new Sequence(lesson.getModulesSequence(), docsAreEqual)
      return {
        lesson: lesson,
        modulesSequence: modulesSequence
      }

    @lessonsSequence = new Sequence(sequence, (first, second) -> docsAreEqual(first.lesson, second.lesson))

    @currentLessonsSequence = ->
      return @lessonsSequence

    @currentModulesSequence = ->
      @lessonsSequence.getCurrentItem()?.modulesSequence

  getName: ->
    return @name

  getImage: ->
    return @image

  getIndex: ->
    return @index

  getCurriculum: () ->
    return @curriculum

  getLessons: ->
    return @lessons

  getCurrentLesson: ->
    return @currentLessonsSequence().getCurrentItem()?.lesson
  
  goToNextLesson: ->
    @currentLessonsSequence()?.goToNext()
    @goToNextModule()

  onLastLesson: ->
    @currentLessonsSequence()?.onLast()

  getLessonIndex: ->
    @currentLessonsSequence()?.getIndex()

  getModuleIndex: ->
    @currentModulesSequence()?.getIndex()

  onLastModule: ->
    @currentModulesSequence()?.onLast()

  goToNextModule: ->
    @currentModulesSequence()?.goToNext()

  getCurrentModules: ->
    return @currentModulesSequence()?.getItems()

  getCurrentModule: ->
    return @currentModulesSequence()?.getCurrentItem()

  isCurrentModule: ( module )->
    if @currentModulesSequence()?
      return @currentModulesSequence().isCurrent module
    else
      return false

  isNextModule: ( module )->
    @currentModulesSequence().isNext module

  resetSequences: ->
    for lessonItem in @lessonsSequence.getItems()
      console.log lessonItem
      lessonItem.modulesSequence.reset()
      console.log "Resetting this modules sequence"
      console.log lessonItem.modulesSequence.getIndex()
    @lessonsSequence.reset()
    console.log "After reset"
    console.log @lessonsSequence
    
  isEqual: ( level )->
    return level.getName() == @getName() and
      level.getImage()== @getImage() and
      level.getCurriculum() == @getCurriculum()

module.exports.LevelModel = LevelModel
