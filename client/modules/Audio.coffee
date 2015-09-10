class @Audio extends BaseNode
  constructor: ( @src, @id )->
    super

    @.setOrigin .5, .5, .5
     .setAlign .5, 0, .6
     .setMountPoint .5, 0, .6
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

    @.setSrc @.src, @.id

  setSrc: ( src, id )=>
    @.id = id
    @.src = src
    @.domElement.setContent "<audio class='full-width' src='#{src}' id='#{@.id}'> Your browser does not support this kind of audio file </audio>"
    #@.domElement.setAttribute "id", @.id
    #@.domElement.setAttribute "src", src
    elem = @.getAudioElement()
    console.log "Here is the audio element"
    console.log @.src
    console.log elem
    #if elem
      #console.log ""
      #console.log $(elem).attr "src"
      #console.log src
      #console.log ""
      #console.log src == $(elem).attr "src"
      #$(elem).addEventListener "canplay", ()->
        #console.log "CAN PLAY EVENT FIRED"

  onUpdate: ()=>
    audio = @.getAudioElement()
    audioSrc = $(audio).attr "src"
    if @.playWhenReady and audio and audioSrc == @.src
      audio.currentTime = 0
      audio.play()
      @.playWhenReady = false

  getAudioElement: ()=>
    return $("##{@.id}")[0]
  
  play: ()=>
    @.playWhenReady = true

  pause: ()->
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
