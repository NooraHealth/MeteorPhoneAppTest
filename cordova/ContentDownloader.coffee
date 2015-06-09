Array::merge = (other) -> Array::push.apply @, other

class @ParsedUrl
  constructor: (@urlString, @endpoint)->
    pieces = urlString.split('/')
    @.pieces = pieces
  directories: ()->
    index = @.pieces.length - 1
    dirs = @.pieces.splice(0, index)
    return dirs
  file: ()->
    return @.pieces[@.pieces.length - 1]
  endpointPath: ()->
    return @.endpoint.concat @.urlString


class @ContentDownloader

  constructor: (@curriculum, @mediaEndpoint)->

  downloadFiles: (urls)->
    onError = (err)->
      console.log "ERROR: ", err
      console.log err

    downloadFile = (targetPath, url)->

    onFileEntrySuccess = (url)->
      return (fileEntry)->
        endpnt = url.endpointPath()
        console.log "endpt: ", endpnt
        uri = encodeURI(endpnt)
        #uri = encodeURI("https://noorahealth-development.s3-west-1.amazonaws.com/NooraHealthContent/Image/activityv.png")
        #targetPath = dirEntry.toParsedUrl().concat(url.getFile())
        targetPath = fileEntry.toURL()
        ft = new FileTransfer()
        onTransferSuccess = (entry)->
          console.log "SUCCESS: ", entry
        onTransferError = (error)->
          console.log "error downloading: ", error
          console.log error

        #download the file from the endpoint and save to target path on mobile device
        ft.download(uri, targetPath, onTransferSuccess, onTransferError )


    onDirEntrySuccess = (url, directories)->
      return (dirEntry)->
        console.log dirEntry.toURL()
        if directories.length == 0
          file = url.file()
          console.log "File: ", file
          dirEntry.getFile file, {create: true, exclusive: false}, onFileEntrySuccess(url), onError
        else
          dir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          dirEntry.getDirectory dir, {create: true, exclusive: false}, onDirEntrySuccess(url, remainingDirs), onError


    window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
      for url in urls
          directories = url.directories()
          firstDir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          fs.root.getDirectory firstDir, {create: true, exclusive: false}, onDirEntrySuccess(url,remainingDirs), onError

  loadContent: ()->
    lessons = @.curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(@.retrieveContentUrls(lesson))

    endURLS = (new ParsedUrl(url, @.mediaEndpoint) for url in urls)
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


