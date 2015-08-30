
###
# Video Surface
###
class @VideoSurface extends ModuleSurface
  constructor: ( @module, index )->
    super @.module, index

    @.setSizeMode Node.RELATIVE_SIZE, Node.RELATIVE_SIZE, Node.RELATIVE_SIZE
     .setProportionalSize 1, 1, 1
     #.setAbsoluteSize 700, 500, 0

    videoSrc = @.module.videoSrc()
    id = @.module._id
    @.domElement = new DOMElement @, {
      properties:
        height: "100%"
      content: "<video id='#{id}' src='#{videoSrc}'  controls> Your browser does not support this video tag, please logout and use another browser </video>"
      
    }

  moveOnstage: ()=>
    super

  moveOffstage: ()=>
    $("#" + @.module._id)[0].pause()
    super

