
class @ModuleImage extends BaseNode
  constructor: (@src)->
    super

    console.log "CREATING AMODULE IMAGE"
    console.log @.src
    @.setOrigin .5, .5, .5
     .setAlign .5, .5, .5
     .setMountPoint .5, .4, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .8

    @.domElement = new DOMElement @
    @.setSrc @.src

  setSrc: ( src )->
    console.trace()
    @.src = src
    console.log "SETTING THE MODULE IMAGE SOURCE"
    console.log src
    endpoint = Scene.get().getContentSrc src
    console.log endpoint
    @.domElement.setContent "<img src='#{endpoint}' class='binary-image'></img>"
