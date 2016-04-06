
###
# Module
#
# A single unit of instructional material, 
# such as a question, a slide, an audio clip, 
# or a video.
###

ContentInterface = require '../content/ContentInterface.coffee'

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

Modules.helpers {

  isEmbedded: ->
    if this.video or !this.video_url then false
    else this.video_url.startsWith "http"

  imgSrc: ->
    if not @image then "" else ContentInterface.getUrl @image

  audioSrc: ->
    if not @audio then "" else ContentInterface.getUrl @audio

  incorrectAnswerAudio: ->
    if not @incorrect_audio then "" else ContentInterface.getUrl @incorrect_audio

  correctAnswerAudio: ->
    if not @correct_audio then "" else ContentInterface.getUrl @correct_audio
  
  videoSrc: ->
    if not @video then "" else ContentInterface.getUrl @video

  isCorrectAnswer: (response) ->
    return response in @correct_answer

  optionSrc: (i) ->
    if not @options[i] then "" else ContentInterface.getUrl @options[i]

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

