class @Header
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, 0
     .setMountPoint 0, 0, 0
     .setAlign 0, 0, 0
     .setSizeMode "relative", "relative"
     .setProportionalSize 1, .075

    @.domElement = new DOMElement @, {
      attributes: {
        class: "nav z-depth-2"
      }
    }

    @.logo = new Logo()
    @.addChild @.logo

    @.menu = new Menu()
    @.addChild @.menu

class Logo
  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin .5, .5, .5
     .setMountPoint 0, 0, 0
     .setAlign .03, .05, .5
     .setSizeMode "absolute", "absolute", "absolute"
     .setAbsoluteSize 30, 30, 10

    @.domElement = new DOMElement @, {
      content: "<a href='/'><img class='round-tile z-depth-2' alt='Noora Health' src='NHlogo.png'/></a>"
    }

class Menu

  constructor: ()->
    @[name] = method for name, method of Node.prototype
    Node.apply @

    @.setOrigin 1, .5, .5
     .setMountPoint .5, .5, 0
     .setAlign 1, .5, 0
     .setSizeMode "relative", "relative"
     .setProportionalSize .5, 1

    @.domElement = new DOMElement @, {
      attributes:
        class: "valign-wrapper"

      content:
        "<div class='nav-menu'>
          <ul class='valign'>
            <li><a href='/selectCurriculum'>Select Curriculum</a></li>
            <li><a onClick='Meteor.logout()'><i class='mdi-action-exit-to-app small'></i></a>
            </ul>
          </div>"
    }
