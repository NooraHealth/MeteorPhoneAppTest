
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
      return first._id is second._id

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
    return @currentLessonsSequence().getCurrent()?.lesson
  
  incrementLesson: ->
    @currentLessonsSequence().goToNext()

  onLastLesson: ->
    @currentLessonsSequence().onLast()

  getNumLessonsCompleted: ->
    @currentLessonsSequence().getNumComplete()

  getNumModulesCompleted: ->
    @currentModulesSequence().getNumComplete()

  onLastModule: ->
    @currentModulesSequence().onLast()

  incrementModule: ->
    @currentModulesSequence().goToNext()

  getCurrentModules: ->
    return @currentModulesSequence()

  getCurrentModule: ->
    return @currentModulesSequence().getCurrent()

  isCurrentModule: ( module )->
    @modulesSequence().isCurrent module

  isNextModule: ( module )->
    @modulesSequence().isNext module

  resetSequences: ->
    for lessonItem in @lessonsSequence.getItems()
      lessonItem.modulesSequence.reset()
    @lessonsSequence.reset()
    
  isEqual: ( level )->
    return level.getName() == @getName() and
      level.getImage()== @getImage() and
      level.getCurriculum() == @getCurriculum()

module.exports.LevelModel = LevelModel
