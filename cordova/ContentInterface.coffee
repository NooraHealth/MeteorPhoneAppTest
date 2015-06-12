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


class @ContentInterface

  constructor: (@curriculum, @contentEndpoint)->
    console.log "Consutricting and this is the endp: ", @.contentEndpoint

  downloadFiles: (urls)->
    deferred = Q.defer()
    numToLoad = urls.length
    numRecieved = 0

    onError = (err)->
      console.log "ON ERR"
      console.log err
      deferred.reject(err)

    onFileEntrySuccess = (url)->
      return (fileEntry)->
        ft = new FileTransfer()
        endpnt = url.endpointPath()
        uri = encodeURI(endpnt)
        targetPath = fileEntry.toURL()

        console.log "THis is the file transfer object"
        console.log ft
        ft.onprogress= (event)->
          console.log "PROGREsS"
          console.log event

        onTransferSuccess = (entry)->
          console.log "TRANSFER SUCCESS"
          console.log entry
          numRecieved++
          if numRecieved == numToLoad
            deferred.resolve(entry)

        onTransferError = (error)->
          console.log "TRANSFER ERROR"
          deferred.reject()

        #download the file from the endpoint and save to target path on mobile device
        ft.download(uri, targetPath, onTransferSuccess, onTransferError)


    onDirEntrySuccess = (url, directories)->
      return (dirEntry)->
        if directories.length == 0
          file = url.file()
          dirEntry.getFile file, {create: true, exclusive: false}, onFileEntrySuccess(url), onError
        else
          dir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          dirEntry.getDirectory dir, {create: true, exclusive: false}, onDirEntrySuccess(url, remainingDirs),onError


    window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
      for url in urls
          directories = url.directories()
          firstDir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          fs.root.getDirectory firstDir, {create: true, exclusive: false}, onDirEntrySuccess(url,remainingDirs), onError

    return deferred.promise

  loadContent: (onSuccess, onError)->
    lessons = @.curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(@.retrieveContentUrls(lesson))

    endURLS = (new ParsedUrl(url, @.contentEndpoint) for url in urls)
    promise = @.downloadFiles endURLS
    promise.then (entry)->
      console.log "PROMISE SUCCESSFUL"
      onSuccess(entry)
    promise.fail (err)->
      console.log "PROMISE REJECTED"
      console.log err
      onError(err)
        
  retrieveContentUrls: (lesson)->
    console.log "RETRIEVING CONTENT URLS"
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


