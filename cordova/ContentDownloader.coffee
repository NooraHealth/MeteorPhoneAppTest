Array::merge = (other) -> Array::push.apply @, other

class @ContentDownloader

  constructor: (@curriculum, @mediaEndpoint)->

  downloadFiles: (urls)->
    console.log "GONNA DOWNLOAD THE FILES", urls
    console.log "FileTransfer: ", FileTransfer
    console.log "FileEntry: ", FileEntry
    for url in urls
      window.requestFileSystem LocalFileSystem.PERSISTENT, 0, (fs)->
        directories = url.directories()
        console.log "Here are the URL obj directories: ", directories
        fs.root.getDirectory "NooraHealthContent/Images/", {create: true, exclusive: false}, (dirEntry)->
          console.log "Got the dir entry: ", dirEntry
          file = dirEntry.getFile "image1.png", {create: true, exclusive: false}, (fileEntry)->
            uri = encodeURI url.endpointPath()
            console.log "URI endpointPath: ", uri
            targetPath = fileEntry.toURL()
            ft = new FileTransfer()
            console.log "endURL:" , targetPath
            onSuccess = (entry)->
              console.log "SUCCESS: ", entry
            onError = (error)->
              console.log "error downloading: ", error
            console.log "About to download"
            ft.download {
              uri,
              targetPath,
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
    endURLS = (new URL(url, @.mediaEndpoint) for url in urls)
    console.log "END URLS: ", endURLS
    @.downloadFiles endURLS

  parseUrl: (url)->
    parsed = {directory: "", filename:"" }
    
        
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


class URL
  constructor: (@urlString, @endpoint)->
    pieces = urlString.split('/')
    @.pieces = pieces
    console.log "Here are the pieces of the url ", pieces
  directories: ()->
    return @.pieces.splice(@.pieces.length - 2, 1)
  file: ()->
    return @.pieces[@.pieces.length - 1]
  endpointPath: ()->
    return @.endpoint.concat @.urlString

