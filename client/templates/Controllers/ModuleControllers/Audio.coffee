class @Audio
  constructor: ( @src, @id, @_module_id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    console.log "CONSTRUCTING AN AUDIO", @.id
    console.trace()
    if @.src
      @.setSrc @.src

  playAudio: ( whenFinished )->
    console.log "Going to play audio!", @.id
    audio = @.getAudioElement()
    audio.currentTime = 0

    if audio.readyState == 0
      audio.load()
      console.log "loading this audio"
      console.log audio
      @._shouldPlayOnReady = true
      audio.addEventListener "canplay", @.checkIfShouldPlay
      audio.addEventListener "error", @.onErrorLoadingAudio

    else if audio and audio.play
      audio.play()
      audio.addEventListener "ended", @.shouldCallback

    if whenFinished
      @._shouldCallback = true
      @.callback = whenFinished

  onErrorLoadingAudio: ( err )=>
    console.log "Error loading audio!", err
    @._shouldCallback = false
    @._shouldPlayOnReady = false

  shouldCallback: ()=>
    console.log "Should I callback?", @._shouldCallback
    console.log "I am ", @.id
    if @._shouldCallback
      console.log "Calling callback ", @.callback
      if @.callback
        @.callback()
    @._shouldCallback = false

  checkIfShouldPlay: ()=>
    console.log "Should play?", @._shouldPlayOnReady
    console.log "I am ", @.id
    console.log @
    if @._shouldPlayOnReady
      console.log "Setting the should play on ready to false for ", @.id
      @.getAudioElement().play()
      @._shouldPlayOnReady = false
      @._shouldCallback = true
      @.getAudioElement().addEventListener "ended", @.shouldCallback

  setSrc: ( src )=>
    console.log $("audio")
    audio = @.getAudioElement()
    audio.src = src

  getAudioElement: ()->
    audioId = @.id + @._module_id
    console.log audioId
    console.log typeof audioId
    console.log $("audio")
    console.log $("#audioEa94pDneMqvSFEgTi")
    return $(audioId)[0]

  playWhenReady: ( whenFinished )=>
    console.log "This is the when finished of the play when ready"
    @.playAudio whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
