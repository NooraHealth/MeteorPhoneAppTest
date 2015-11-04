class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    @.setSrc @.src

  @playAudio: ( tag, whenFinished )->
    audio = $(tag)[0]
    audio.currentTime = 0

    playCallback = ( elem )->
      return ()->
        console.log "Can play fired!"
        console.log elem
        console.log "playign elem"
        elem.play()
          
    whenFinishedCallback = ( callback )->
      return ()->
        console.log "Finished callback!"
        callback()

    if audio.readyState == 0
      console.log "Audio ready state"
      console.log audio.readyState
      console.log audio
      audio.load()
      audio.addEventListener "canplay", playCallback(audio)

    else if audio and audio.play
      console.log "Playing elem 2"
      console.log audio
      audio.play()

    if whenFinished
      console.log "When finished: "
      console.log whenFinishedCallback
      audio.addEventListener "ended", whenFinishedCallback(whenFinished)

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src

  getAudioElement: ()->
    return $(@.id)[0]

  playWhenReady: ( whenFinished )=>
    console.log "This is the when finished of the play when ready"
    Audio.playAudio @.getAudioElement(), whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
