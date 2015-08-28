class @Audio extends Node
  constructor: (@src, @id)->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, 0
     .setMountPoint 0, 0, 0

    @.domElement = new DOMElement @
    @.setSrc @.src

  setSrc: (src)=>
    @.src = src
    @.domElement.setContent "<audio id='#{@.id}' src='#{@.src}' controls> Your browser does not support this audio file.</audio>"

  play: ()->
    console.log "About to play"
    console.log $("##{@.id}")[0]
    $("##{@.id}")[0].play()

  pause: ()->
    $("##{@.id}")[0].pause()
