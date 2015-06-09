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
        console.log "FileEntru"
        #uri = encodeURI(url.endpointPath())
        uri = encodeURI("https://noorahealth-development.s3-west-1.amazonaws.com/NooraHealthContent/Image/activityv.png")
        console.log "URI endpointPath: ", uri
        #targetPath = dirEntry.toParsedUrl().concat(url.getFile())
        targetPath = fileEntry.toURL()
        console.log "targetPath:" , targetPath
        ft = new FileTransfer()
        onTransferSuccess = (entry)->
          console.log "SUCCESS: ", entry
        onTransferError = (error)->
          console.log "error downloading: ", error
        console.log "About to download"
        console.log typeof uri
        ft.download(uri, targetPath, onTransferSuccess, onTransferError )


    onDirEntrySuccess = (url, directories)->
      return (dirEntry)->
        console.log dirEntry.toURL()
        if directories.length == 0
          dirEntry.getFile "image1.png", {create: true, exclusive: false}, onFileEntrySuccess(url), onError
        else
          remainingDirs = directories.splice(0)
          console.log "Remaining getDirectory: ", remainingDirs
          dirEntry.getDirectory nextDirectories[0], {create: true, exclusive: false}, onDirEntrySuccess(url, remainingDirs), onError


    for url in urls
      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
        directories = url.directories()
        console.log "HERE ARE THE DIRECTORIES: ", directories
        fs.root.getDirectory directories[0], {create: true, exclusive: false}, onDirEntrySuccess(url,directories.splice(0)), onError

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


