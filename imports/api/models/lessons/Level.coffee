
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
      console.log "Comparing theseee"
      console.log first
      console.log second
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
    @currentModulesSequence().isCurrent module

  isNextModule: ( module )->
    @currentModulesSequence().isNext module

  resetSequences: ->
    for lessonItem in @lessonsSequence.getItems()
      lessonItem.modulesSequence.reset()
    @lessonsSequence.reset()
    
  isEqual: ( level )->
    return level.getName() == @getName() and
      level.getImage()== @getImage() and
      level.getCurriculum() == @getCurriculum()

module.exports.LevelModel = LevelModel
