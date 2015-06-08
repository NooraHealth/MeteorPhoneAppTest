Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader

  constructor: (@curriculum, @mediaEndpoint)->

  downloadFiles: (urls)->
    onError = (err)->
      console.log "ERROR: ", err
      console.log err

    downloadFile = (targetPath, url)->

    onFileEntrySuccess = (url)->
      return (fileEntry)->
        console.log "FileEntru"
        uri = encodeURI url.endpointPath()
        console.log "URI endpointPath: ", uri
        #targetPath = dirEntry.toURL().concat(url.getFile())
        targetPath = fileEntry.toURL()
        console.log "targetPath:" , targetPath
        #ft = new FileTransfer()
        #onTransferSuccess = (entry)->
          #console.log "SUCCESS: ", entry
        #onTransferError = (error)->
          #console.log "error downloading: ", error
        #console.log "About to download"
        #ft.download {
          #uri,
          #targetPath,
          #onTransferSuccess,
          #onTransferError
        #}


    onDirEntrySuccess = (url)->
      return (dirEntry)->
        console.log "Dir entry success"
        console.log dirEntry
        console.log dirEntry.toURL()
        dirEntry.getFile "image1.png", {create: true, exclusive: false}, onFileEntrySuccess(url), onError


    for url in urls
      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
        console.log "REQUESTED file system"
        onSuccess = onDirEntrySuccess(url)
        fs.root.getDirectory "NooraHealthContent/", {create: true, exclusive: false},onSuccess, onError

  loadContent: ()->
    lessons = @.curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(@.retrieveContentUrls(lesson))

    endURLS = (new URL(url, @.mediaEndpoint) for url in urls)
    @.downloadFiles endURLS
        
  retrieveContentUrls: (lesson)->
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


class URL
  constructor: (@urlString, @endpoint)->
    pieces = urlString.split('/')
    @.pieces = pieces
  directories: ()->
    return @.pieces.splice(@.pieces.length - 2, 1)
  file: ()->
    return @.pieces[@.pieces.length - 1]
  endpointPath: ()->
    return @.endpoint.concat @.urlString

