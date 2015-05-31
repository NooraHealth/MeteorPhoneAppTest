
loadLesson = (lesson)->
  modules = lesson.getModulesSequence()
  imgSrc = lesson.imgSrc()
  console.log "---------------- Downloading Lesson ---------------- "
  console.log imgSrc
  for module in modules
    loadModule(module)

loadModule = (module)->
  console.log "** Downloading Module **"
  console.log FileTransfer
  #ft = new FileTransfer()
  imageUrl = module.imgSrc()
  videoSrc = module.videoSrc()
  audioSrc = module.audioSrc()
  incorrectAnswerAudio = module.incorrectAnswerAudio()
  correctAnswerAudio = module.correctAnswerAudio()
  optionUrls = (option.optionImgSrc for option in module.getOptionObjects())
  console.log "These are the optionUrls: ", optionUrls
  console.log imageUrl
  console.log audioSrc
  console.log videoSrc
  console.log incorrectAnswerAudio
  console.log correctAnswerAudio

Meteor.loadContent =  ()->
  console.log "is this cordova? "
  console.log "This is the meteor objection: ", Meteor
  console.log "FileUploadTransfer: ", FileUploadOptions
  curriculumId = Meteor.user().curriculumId
  curr = Curriculum.findOne()
  console.log "LOADING CURRICULUM: ", curr
  lessons = curr.getLessonDocuments()
  for lesson in lessons
    loadLesson lesson

