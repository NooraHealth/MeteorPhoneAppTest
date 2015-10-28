class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
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
        Audio.playAudio @.getAudioElement()
        @._playWhenReady = false
      @._readyToPlay = true

  getAudioElement: ()->
    return $(@.id)[0]

  playWhenReady: ()=>
    if @._readyToPlay
      Audio.playAudio @.getAudioElement()
    else
      @._playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
