class @Audio extends Node
  constructor: (@src, @id)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 1, 0
     .setMountPoint 0, 1, 0
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .1

    @.domElement = new DOMElement @ ,
      tagName: "audio"
      content: "Your browser does not support this audio file"

    @.setSrc @.src

  setSrc: (src)=>
    @.src = src
    @.domElement.setAttribute "id", @.id
    @.domElement.setAttribute "src", src
    audio = @.getAudioElement()

  getAudioElement: ()=>
    return $("##{@.id}")[0]
  
  play: ()=>
    @.domElement.setAttribute "controls", true
    audio = @.getAudioElement()
    if audio and audio.readyState == 4
      audio.play()
    else
      @.playWhenReady = true

  pause: ()->
    @.domElement.setAttribute "controls", false
    audio = @.getAudioElement()
    if audio and audio.pause
      audio.pause()
