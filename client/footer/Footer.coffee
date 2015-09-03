class @Footer extends BaseNode
  constructor: ()->
    super

    @.setOrigin .5, .5, 0
     .setMountPoint 0, 1, .5
     .setAlign 0, .925, .5
     .setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, .075
     .setAbsoluteSize 0, 60

    @.domElement = new DOMElement @, {
      attributes: {
        class: "white z-depth-2"
      }
    }
    @.next = new NextBtn()
    @.goBack = new GoBackToHome()

    @.addChild @.next
    @.addChild @.goBack

  modulesMode: ()->
    @.next.show()
    @.goBack.show()

  lessonsPageMode: ()->
    @.next.hide()
    @.goBack.hide()
