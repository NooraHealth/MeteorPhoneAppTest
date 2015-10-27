class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @.setSrc @.src

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src
    audio.addEventListener "canplay", ()=>
      if @._playWhenReady
        @._play()
        @._playWhenReady = false
      @._readyToPlay = true

  getAudioElement: ()->
    return $(@.id)[0]

  _play: ()=>
    audio = @.getAudioElement()
    if audio and audio.play
      audio.currentTime = 0
      audio.play()

  playWhenReady: ()=>
    if @._readyToPlay
      @._play()
    else
      @._playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
