Template.registerHelper 'isLastModule', () ->
  index = Session.get "current module index"
  sequence = Session.get "module sequence"
  if !sequence?
    return false
  return index == sequence.length - 1

Template.registerHelper 'pathToCurrentChapterPage', ()->
  chapter = Session.get "current chapter"
  if !chapter?
    return '/'
  else
    return '/chapter/' + chapter.nh_id

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

this.playAnswerAudio = (response, module)->
  nh_id = module.nh_id
  $("audio[name=audio#{nh_id}][class=question]")[0].pause()
  if $(response).hasClass "correct"
    $("audio[name=audio#{nh_id}][class=correct]")[0].play()
  else
    $("audio[name=audio#{nh_id}][class=incorrect]")[0].play()

