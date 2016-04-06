Modules = new Mongo.Collection("nh_modules")

ModuleSchema = new SimpleSchema
  type:
    type:String
  title:
    type:String
    optional:true
  image:
    type:String
    optional: true
  #QUESTION MODULE
  question:
    type:String
    optional:true
  explanation:
    type:String
    optional:true
  options:
    type:[String]
    optional:true
  correct_answer:
    type:[String]
    optional:true
  incorrect_audio:
    type:String
    optional:true
  correct_audio:
    type:String
    optional:true
  video:
    type:String
    optional:true
  audio:
    type:String
    optional:true

Modules.attachSchema ModuleSchema

NUM_OBJECTS_PER_ROW = 3

###
# Module
#
# A single unit of instructional material, 
# such as a question, a slide, an audio clip, 
# or a video.
###

Modules.helpers {

  isEmbedded: ->
    if this.video or !this.video_url then false
    else this.video_url.startsWith "http"

  imgSrc: ->
    if not @image then "" else Meteor.getContentSrc() + @image

  audioSrc: ->
    if not @audio then "" else Meteor.getContentSrc() + @audio

  incorrectAnswerAudio: ->
    if not @incorrect_audio then "" else Meteor.getContentSrc() + @incorrect_audio

  correctAnswerAudio: ->
    if not @correct_audio then "" else Meteor.getContentSrc() + @correct_audio
  
  videoSrc: ->
    if not @video then "" else Meteor.getContentSrc() + @video

  isCorrectAnswer: (response) ->
    return response in @correct_answer

  getOptions: (start, end) ->
    url = Meteor.getContentSrc()
    module = @

    if not @.options
      return []

    isCorrect = (option)=>
      return option in @.correct_answer

    newArr = ({option: option, optionImgSrc: url + option, nh_id: module.nh_id, i: i, correct: isCorrect(option)} for option, i in @.options when i >= start and i < end)
    return {options: newArr}

  option: (i) ->
    return @options[i]

  isVideoModule: ->
    return @type == "VIDEO"

  isBinaryModule: ->
    return @type == "BINARY"

  isMultipleChoiceModule: ->
    return @type == "MULTIPLE_CHOICE"

  isSlideModule: ->
    return @type == "SLIDE"
  
  isGoalChoiceModule: ->
    return @type == "GOAL_CHOICE"

  isScenarioModule: ->
    return @type == "SCENARIO"
}

Ground.Collection Modules

module.exports.Modules = Modules

