class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    @.setSrc @.src

  @playAudio: ( tag, whenFinished )->
    audio = $(tag)[0]
    if audio and audio.play
      audio.currentTime = 0
      audio.play()

    if whenFinished
      audio.addEventListener "ended", whenFinished

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src
    audio.addEventListener "canplay", ()=>
      if @._playWhenReady
        Audio.playAudio @.getAudioElement(), @._whenFinished
        @._playWhenReady = false
        @._whenFinished = null

      @._readyToPlay = true

  getAudioElement: ()->
    return $(@.id)[0]

  playWhenReady: ( whenFinished )=>
    if @._readyToPlay
      Audio.playAudio @.getAudioElement(), whenFinished
    else
      @._playWhenReady = true
      @._whenFinished = whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
