class @Audio
  constructor: ( @src, @id )->
    @._readyToPlay = false
    @._playWhenReady = false
    @._whenFinished = null
    @.setSrc @.src

  @playAudio: ( tag, whenFinished )->
    audio = $(tag)[0]
    audio.currentTime = 0

    if audio.readyState < 3
      console.log "Audio ready state"
      console.log audio.readyState
      console.log audio
      @._playWhenReady = true
      audio.addEventListener "canplay", ()=>
        console.log "Can play fired!"
        console.log audio
        if @._playWhenReady
          audio.play()
          @._playWhenReady = false
          #@._whenFinished = null

    else if audio and audio.play
      audio.play()

    if whenFinished
      audio.addEventListener "ended", whenFinished

  setSrc: ( src )=>
    audio = @.getAudioElement()
    audio.src = src
    audio.load()

  getAudioElement: ()->
    return $(@.id)[0]

  playWhenReady: ( whenFinished )=>
    #if @._readyToPlay
    Audio.playAudio @.getAudioElement(), whenFinished
    #else
      #@._playWhenReady = true
      #@._whenFinished = whenFinished

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
