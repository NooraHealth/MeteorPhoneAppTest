class @Audio extends BaseNode
  constructor: (@src, @id)->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .6
     .setMountPoint .5, .5, .6
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .4, .1

    #@.setOrigin .5, .5, .5
     #.setAlign 0, 1, 0
     #.setMountPoint 0, 1, 0
     #.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     #.setProportionalSize 1, .1

    @.domElement = new DOMElement @
      #tagName: "audio"
      #content: "Your browser does not support this audio file"

    @.setSrc @.src

  setSrc: (src)=>
    @.src = src
    @.domElement.setContent "<audio class='full-width' src='#{src}' id='#{@.id}' controls> Your browser does not support this kind of audio file </audio>"
    #@.domElement.setAttribute "id", @.id
    #@.domElement.setAttribute "src", src
    console.log "Just set the src"
    console.log @.domElement
    
  onUpdate: ()=>
    audio = @.getAudioElement()
    if @.playWhenReady and audio
      console.log "There was a play when ready!"
      @.play()
      @.playWhenReady = false

  getAudioElement: ()=>
    return $("##{@.id}")[0]
  
  play: ()=>
    @.domElement.setAttribute "controls", true
    audio = @.getAudioElement()
    console.log "Audio"
    console.log audio
    if audio
      console.log "READY STATE?"
      console.log audio.readyState
    if audio# and audio.readyState == 4
      audio.play()
    else
      @.playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    console.log "Here is the pause audio"
    console.log audio
    if audio and audio.pause
      audio.pause()
