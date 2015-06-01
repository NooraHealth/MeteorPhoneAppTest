Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader
  constructor: (@curriculum)->

  downloadFiles: (urls)->


  loadContent: ()->
    lessons = curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(retrieveContentUrls lesson)

    downloadFiles urls
      
  retrieveContentUrls: (lesson)->
    console.log "---------------- Content URLS ---------------- "
    if not lesson? or not lesson.getModulesSequence?
      throw Meteor.Error "retrieveContentUrls argument must be a Lesson document"

    modules = lesson.getModulesSequence()
    urls = []
    if lesson.image
      urls.push lesson.imgSrc()

    for module in modules
      urls.merge(@.moduleUrls(module))
    
    return urls


  moduleUrls: (module)->
    urls = []
    if module.image
      urls.push module.imgSrc()
    if module.video
      urls.push module.videoSrc()
    if module.audio
      urls.push module.audioSrc()
    if module.incorrect_audio
      urls.push module.incorrectAnswerAudio()
    if module.correct_audio
      urls.push module.correctAnswerAudio()
    if module.options and ( module.type == 'MULTIPLE_CHOICE' or module.type == 'GOAL_CHOICE')
      urls.push option.optionImgSrc for option in module.getOptionObjects()
    return urls

