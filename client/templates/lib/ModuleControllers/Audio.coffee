class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @.setSrc @.src

  setSrc: ( src )=>
    audio = @.getAudioElement()
    console.log "AUDIO ELEMENT"
    console.log audio
    audio.src = src
    audio.addEventListener "canplay", ()=>
      console.log "CAN PLAY"
      console.log @._playWhenReady
      if @._playWhenReady
        @._play()
        @._playWhenReady = false
      @._readyToPlay = true

  getAudioElement: ()->
    return $(@.id)[0]

  _play: ()=>
    console.log "PLAYING"
    audio = @.getAudioElement()
    console.log audio
    if audio and audio.play
      console.log "PLAYING IN ID"
      audio.currentTime = 0
      audio.play()

  playWhenReady: ()=>
    console.log "Going to play when ready"
    console.log "ready to play?", @._readyToPlay
    console.log "play when ready?", @._playWhenReady
    if @._readyToPlay
      @._play()
    else
      @._playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
