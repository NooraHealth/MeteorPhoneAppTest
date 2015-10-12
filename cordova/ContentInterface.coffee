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

  clearContentDirectory: ()->
    deferred = Q.defer()
    removeDir = (dirEntry)->
      if dirEntry
        dirEntry.removeRecursively(()->
          deferred.resolve()
        , (err)->
            console.log "Error removing directory"
            console.log err
            deferred.reject(err)
        )

    onError = (err)->
      console.log "Error getting the directory to delete it"
      console.log err
      if err.code == 1
        deferred.resolve("The directory does not exist to delete")
      deferred.reject err

    window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
      fs.root.getDirectory '/NooraHealthContent/', {create: false, exclusive: false}, removeDir, onError

    return deferred.promise

  downloadFiles: (urls)->
    deferred = Q.defer()
    numToLoad = urls.length
    numRecieved = 0
    urlsToTryAgain = []

    onError = (url)->
      return (err)->
        deferred.reject(err)

    onFileEntrySuccess = (url)->
      return (fileEntry)->
        ft = new FileTransfer()
        endpnt = url.endpointPath()
        uri = encodeURI(endpnt)
        targetPath = fileEntry.toURL()

        ft.onprogress = (event)->
          percent = numRecieved/numToLoad
          Session.set "percent loaded", percent
          #total = Session.get "total bytes"
          #if !total
            #total = event.total
            #Session.set "total bytes", total
          #bytesLoaded = event.loaded
          #Session.set "bytes downloaded", bytesLoaded

        onTransferSuccess = (entry)->
          console.log "TRANSFER SUCCESS"
          console.log entry
          numRecieved++
          if numRecieved == numToLoad
            deferred.resolve(entry)

        onTransferError = (error)->
          console.log "ERROR "
          console.log error
          console.log "Checking http status"
          console.log error["http_status"] == 404
          if error["http_status"] == 404
            numRecieved++
            if numRecieved == numToLoad
              deferred.resolve(entry)
          if error.code == 3
            #try to download the file again
            ft.download(uri, targetPath, onTransferSuccess, onTransferError)
          else
            deferred.reject(error)

        #download the file from the endpoint and save to target path on mobile device
        ft.download(uri, targetPath, onTransferSuccess, onTransferError)

    fileFound = ()->
      numRecieved++
      console.log "Num recieved/numToLoad: "+ numRecieved + "/"+ numToLoad
      if numRecieved == numToLoad
        deferred.resolve()
      
    fileNotFound = (dirEntry, file, url)->
      return (err)->
        dirEntry.getFile file, {create: true, exclusive: false}, onFileEntrySuccess(url), onError(file)


    onDirEntrySuccess = (url, directories)->
      return (dirEntry)->
        if directories.length == 0
          file = url.file()
          dirEntry.getFile file, {create: false, exclusive: false}, fileFound, fileNotFound(dirEntry, file, url)
        else
          dir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          dirEntry.getDirectory dir, {create: true, exclusive: false}, onDirEntrySuccess(url, remainingDirs),onError


    window.requestFileSystem LocalFileSystem.PERSISTENT, 5*1024*1024, (fs)->
      for url in urls
        directories = url.directories()
        #TODO: this should be done in the object
        firstDir = directories[0] + '/'
        remainingDirs = directories.splice(1)
        fs.root.getDirectory firstDir, {create: true, exclusive: false}, onDirEntrySuccess(url,remainingDirs), onError(url)
        #path = "/"+url.localFilePath()
        #fullPath = fs.root.toURL() + path
        #window.resolveLocalFileSystemURL fullPath, onFileEntrySuccess(url), onError(url)
        #fs.root.getFile path, {create: true, exclusive: false}, onFileEntrySuccess(url), onError(url)
    , (err)->
      console.log "ERROR requesting local filesystem: "
      console.log err
      promise.reject err

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
    try
      if not lesson? or not lesson.getModulesSequence?
        throw Meteor.Error "retrieveContentUrls argument must be a Lesson document"

      modules = lesson.getModulesSequence()
      urls = []
      if lesson.image
        urls.push lesson.image

      for module in modules
        urls.merge(@.moduleUrls(module))
    catch err
      console.log "Error caught in retrieve content urls: "
      console.log err
      throw Meteor.error "error retrieving content urls:", err
    finally
      return urls


  moduleUrls: (module)->
    urls = []
    console.log "ModuleURLS: "
    console.log module
    if module.image
      urls.push module.image
    if module.video
      urls.push module.video
    if module.audio
      urls.push module.audio
    if module.incorrect_audio
      urls.push module.incorrect_audio
    if module.correct_audio
      urls.push module.correct_audio
    if module.options and ( module.type == 'MULTIPLE_CHOICE' or module.type == 'GOAL_CHOICE')
      urls.merge (option for option in module.options when option?)
    return urls


