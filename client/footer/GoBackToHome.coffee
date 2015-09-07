
class @GoBackToHome extends BaseNode
  constructor: ()->
    super

    @.setOrigin .5, .5, .5
     .setMountPoint 0, .5, .5
     .setAlign .05, .5, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize .2, .75, 0

    @.domElement = ResponseButton.getButtonDomElement(@)
    @.domElement.setContent "GO HOME"
    @.domElement.addClass "green"
    
    @.addUIEvent "click"

  onReceive: (e, payload) ->
    if e == 'click'
      Scene.get().goToLessonsPage()
      payload.stopPropagation()
