
class @NextBtn extends BaseNode
  constructor: ()->
    super

    @.setOrigin .5, .5, .5
     .setMountPoint 1, .5, .5
     .setAlign .95, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .2, .75, 0

    @.domElement = ResponseButton.getButtonDomElement(@)
    @.domElement.setContent "NEXT <i class='mdi-navigation-arrow-forward medium'/>"
    
    @.addUIEvent "click"

  onReceive: (e, payload) ->
    if e == 'click'
      Scene.get().goToNextModule()
      payload.stopPropagation()
