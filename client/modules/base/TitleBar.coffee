class @TitleBar extends BaseNode
  constructor: ( @title, @size )->
    super

    @.setOrigin .5, .5, .5
     .setAlign 0, 0, .5
     .setMountPoint 0, 0, .5
     .setSizeMode Node.ABSOLUTE_SIZE, Node.ABSOLUTE_SIZE
     .setAbsoluteSize @.size.x, @.size.y
    
    @.domElement = new DOMElement @
    @.setTitle @.title

    @.domElement.addClass "card-content"
    @.domElement.addClass "flow-text"
    @.domElement.addClass "grey-text"
    @.domElement.addClass "text-darken-2"

  setTitle: ( title )->
    @.title = title
    @.domElement.setContent "#{@.title}"
