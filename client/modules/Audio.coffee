class @Audio
  constructor: ( @src, @id )->
    @.setSrc @.src, @.id

  setSrc: ( src, id )=>

  onUpdate: ()=>
    audio = @.getAudioElement()
    audioSrc = $(audio).attr "src"
    if @.playWhenReady and audio and audioSrc == @.src
      audio.currentTime = 0
      audio.play()
      @.playWhenReady = false
  
  play: ()=>
    @.playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
