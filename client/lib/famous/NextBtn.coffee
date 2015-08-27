class @NextBtn extends Node
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setMountPoint 1, 1, 0
     .setAlign .9, .9, .5
     .setSizeMode "absolute", "absolute", "absolute"
     .setAbsoluteSize 80, 30, 0

    @.domElement = new DOMElement @, {
      content: "
      <a class='center-align next-module-btn blue rounded blue-text text-lighten-3 flow-text btn-flat waves-effect waves-light'>
        NEXT <i class='mdi-navigation-arrow-forward medium'></i>
      </a>"
    }

    @.addUIEvent "click"

  onReceive: (e, payload) ->
    if e == 'click'
      Scene.get().goToNextModule()


