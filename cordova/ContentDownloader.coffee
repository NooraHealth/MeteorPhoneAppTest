Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader

  constructor: (@curriculum, @mediaEndpoint)->

  downloadFiles: (urls)->
    console.log "GONNA DOWNLOAD THE FILES", urls
    console.log "FileTransfer: ", FileTransfer
    console.log "FileEntry: ", FileEntry
    for url in urls
      ft = new FileTransfer()
      console.log "FT: ", ft
      uri = encodeURI url
      console.log "URI: ", uri
      endURL = FileEntry.toURL()
      console.log "endURL:" , endURL
      onSuccess = (entry)->
        console.log "SUCCESS: ", entry
      onError = (error)->
        console.log "error downloading: ", error
      console.log "About to download"
      ft.download {
        uri,
        endURL,
        onSuccess,
        onError
      }

  loadContent: ()->
    console.log "This is the curriculum: ", @.curriculum
    lessons = @.curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(@.retrieveContentUrls(lesson))

    console.log "HERE ARE ALL THE URLS: ", urls
    console.log typeof urls
    console.log urls.length
    console.log urls[2]
    console.log "MEDIA ENDPOINT: ", @.mediaEndpoint
    endURLS = (@.mediaEndpoint.concat(url) for url in urls)
    console.log "END URLS: ", endURLS
    @.downloadFiles endURLS
        
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

