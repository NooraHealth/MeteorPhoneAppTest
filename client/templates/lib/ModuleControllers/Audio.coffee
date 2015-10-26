class @Audio
  constructor: ( @src, @id )->
    @.readyToPlay = false
    @.playWhenReady = false
    @.setSrc @.src

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.attr "src", src
    console.log @.getAudioElement()
    audio.on "canplay", ()=>
      console.log "CAN PLAY"
      if @.playWhenReady
        @._play()
        @.playWhenReady = false

      @.readyToPlay = true

  getAudioElement: ()->
    return $(@.id)

  _play: ()=>
    audio = @.getAudioElement()
    if audio and audio.play
      audio.currentTime = 0
      audio.play()

  playWhenReady: ()=>
    if @.readyToPlay
      @._play()
    else
      @.playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
