Array::merge = (other) -> Array::push.apply @, other

class @ParsedUrl
  constructor: (@urlString, @endpoint)->
    pieces = urlString.split('/')
    @.pieces = pieces
  directories: ()=>
    index = @.pieces.length - 1
    dirs = @.pieces.splice(0, index)
    return dirs
  file: ()=>
    return @.pieces[@.pieces.length - 1]
  endpointPath: ()=>
    return @.endpoint.concat @.urlString


class @LocalContent extends Base

  constructor: (@curriculum, @contentEndpoint)->
    @.tag = "LocalContent"
    super()

  @getLocalFilesSystem: (bytes)=>
    deferred = Q.defer()
    window.requestFileSystem LocalFileSystem.PERSISTENT, bytes, (filesystem)=>
      deferred.resolve filesystem
    , (error)=>
      deferred.reject error
    return deferred.promise

  clearContentDirectory: ()=>
    deferred = Q.defer()
    removeDir = (dirEntry)=>
      if dirEntry
        dirEntry.removeRecursively(()=>
          deferred.resolve()
        , (err)=>
            deferred.reject(err)
        )

    onError = (err)=>
      if err.code == 1
        deferred.resolve("The directory does not exist to delete")
      deferred.reject err

    @.getLocalFilesSystem(0)
    .then (fs)=>
      if error
        deferred.reject error
      else
        fs.root.getDirectory '/NooraHealthContent/', {create: false, exclusive: false}, removeDir, onError
    .fail (error)=>
      deferred.reject error

    return deferred.promise

  downloadFiles: (urls)=>
    @.log @.tag, "LOG", "In the download files"
    deferred = Q.defer()
    numToLoad = urls.length
    numRecieved = 0
    urlsToTryAgain = []

    onError = (url)=>
      return (err)=>
        deferred.reject(err)

    onFileEntrySuccess = (url)=>
      return (fileEntry)=>
        ft = new FileTransfer()
        endpnt = url.endpointPath()
        uri = encodeURI(endpnt)
        targetPath = fileEntry.toURL()

        ft.onprogress = (event)=>
          percent = numRecieved/numToLoad
          Session.set "percent loaded", percent
          #total = Session.get "total bytes"
          #if !total
            #total = event.total
            #Session.set "total bytes", total
          #bytesLoaded = event.loaded
          #Session.set "bytes downloaded", bytesLoaded

        onTransferSuccess = (entry)=>
          @.log @.tag, "LOG", "Transfer success!" , entry, numRecieved + "/"+ numToLoad
          numRecieved++
          if numRecieved == numToLoad
            deferred.resolve(entry)

        onTransferError = (error)=>
          @.log @.tag, "ERROR", "Trensfer Error! " , error
          if error.code == 3
            #try to download the file again
            ft.download(uri, targetPath, onTransferSuccess, onTransferError)
          else
            deferred.reject(error)

        #download the file from the endpoint and save to target path on mobile device
        ft.download(uri, targetPath, onTransferSuccess, onTransferError)

    fileFound = ()=>
      numRecieved++
      @.log @.tag, "LOG", "File Found ", numRecieved/numToLoad
      if numRecieved == numToLoad
        deferred.resolve()
      
    fileNotFound = (dirEntry, file, url)=>
      return (err)=>
        @.log @.tag, "LOG", "File not Found, about to download fresh"
        dirEntry.getFile file, {create: true, exclusive: false}, onFileEntrySuccess(url), onError(file)

    onDirEntrySuccess = (url, directories)=>
      return (dirEntry)=>
        if directories.length == 0
          file = url.file()
          dirEntry.getFile file, {create: false, exclusive: false}, fileFound, fileNotFound(dirEntry, file, url)
        else
          dir = directories[0] + '/'
          remainingDirs = directories.splice(1)
          dirEntry.getDirectory dir, {create: true, exclusive: false}, onDirEntrySuccess(url, remainingDirs), onError(dir)


    @.log @.tag, "DEBUG", "About to get the local filesystem"
    LocalContent.getLocalFilesSystem(0)
    .then (fs)=>
      @.log @.tag, "LOG", "Got the local filesystem", fs
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
    .fail (err)=>
      @.log @.tag, "ERROR", "Error requesting the local filesystem", err
      promise.reject err

    return deferred.promise

  loadContent: (onSuccess, onError)=>
    lessons = @.curriculum.getLessonDocuments()
    urls = []
    for lesson in lessons
      urls.merge(@.retrieveContentUrls(lesson))
    
    endURLS = (new ParsedUrl(url, @.contentEndpoint) for url in urls)
    
    @.log @.tag, "DEBUG", "About to call download files"
    @.downloadFiles endURLS
    .then (entry)=>
      onSuccess(entry)
    .fail (err)=>
      onError(err)
  
  retrieveContentUrls: (lesson)=>
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
      throw Meteor.error "error retrieving content urls:", err
    finally
      return urls


  moduleUrls: (module)=>
    urls = []
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


