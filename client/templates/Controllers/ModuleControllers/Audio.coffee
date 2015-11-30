class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    if @.src
      @.setSrc @.src

  playAudio: ( whenFinished )->
    console.log "Going to play audio!", @.id
    audio = @.getAudioElement()
    audio.currentTime = 0

    if audio.readyState == 0
      console.log "Ready state 0!"
      audio.load()
      @._shouldPlayOnReady = true
      audio.addEventListener "canplay", @.checkIfShouldPlay()

    else if audio and audio.play
      console.log "NOPE PLAY"
      audio.play()

    if whenFinished
      @._shouldCallback = true
      @.callback = whenFinished
      audio.addEventListener "ended", @.shouldCallback()

  shouldCallback: ()->
    console.log "Should I callback?", @._shouldCallback
    if @._shouldCallback
      if @.callback
        @.callback()
    @._shouldCallback = false

  checkIfShouldPlay: ()->
    console.log "Play on Ready?" , @._shouldPlayOnReady
    if @._shouldPlayOnReady
      @.getAudioElement().play()
      @._shouldPlayOnReady = false

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src

  getAudioElement: ()->
    return $(@.id)[0]

  playWhenReady: ( whenFinished )=>
    console.log "This is the when finished of the play when ready"
    @.playAudio whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
