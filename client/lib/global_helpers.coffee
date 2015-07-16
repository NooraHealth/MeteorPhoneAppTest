#FView.registerView "ContainerSurface", famous.views.ContainerSurface

Template.registerHelper 'isPhone', ()->
  return Meteor.Device.isPhone()

Template.registerHelper 'isLastModule', () ->
  index = Session.get "current module index"
  sequence = Session.get "module sequence"
  if !sequence?
    return false
  return index == sequence.length - 1

Template.registerHelper 'isFirstModule', ()->
  return Session.equals "current module index", 0

Template.registerHelper 'currentChapterTitle', ()->
  chapter = Session.get "current chapter"
  if !chapter?
    return null
  if chapter.short_title
    return chapter.short_title
  else
    return chapter.title

Template.registerHelper 'currentSectionTitle', ()->
  section = Session.get "current section"
  if !section?
    return null
  if section.short_title
    return section.short_title
  else
    return section.title

Template.registerHelper 'currentModuleTitle', ()->
  index = Session.get "current module index"
  sequence = Session.get "module sequence"
  if !sequence?
    return null
  return sequence[index].title

Template.registerHelper 'isCorrectAnswer', (response)->
  #all possible answers to lowercase
  answers = (answer.toLowerCase() for answer in Template.instance().data.correct_answer)
  return response.toLowerCase() in answers

Template.registerHelper 'imgSrc', ()->
  if not @.image
    return ""
  url = Meteor.NooraClient.getContentSrc()
  return url + @.image

Template.registerHelper 'correctAnswerAudio', ()->
  if not @.correct_audio
    return ""
  ModuleSurface.correctAnswerAudio(@)

Template.registerHelper 'incorrectAnswerAudio', ()->
  if not @.correct_audio
    return ""
  ModuleSurface.incorrectAnswerAudio(@)

Template.registerHelper 'videoSrc', ()->
  if not @.video
    return ""
  ModuleSurface.videoSrc(@)

Template.registerHelper 'audioSrc', ()->
  if not @.audio
    return ""
  ModuleSurface.audioSrc(@)

  



