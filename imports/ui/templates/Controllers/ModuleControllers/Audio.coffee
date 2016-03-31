class @Audio
  constructor: ( @src, @id, @_module_id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    
    if @.src
      @.setSrc @.src

  playAudio: ( whenFinished )->
    audio = @.getAudioElement()
    audio.currentTime = 0

    if audio.readyState == 0
      audio.load()
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
    @._shouldCallback = false
    @._shouldPlayOnReady = false

  shouldCallback: ()=>
    if @._shouldCallback
      if @.callback
        @.callback()
    @._shouldCallback = false

  checkIfShouldPlay: ()=>
    if @._shouldPlayOnReady
      @.getAudioElement().play()
      @._shouldPlayOnReady = false
      @._shouldCallback = true
      @.getAudioElement().addEventListener "ended", @.shouldCallback

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src

  getAudioElement: ()->
    audioId = @.id + @._module_id
    return $(audioId)[0]

  playWhenReady: ( whenFinished )=>
    @.playAudio whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
