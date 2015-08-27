
###
# Video Surface
###
class @VideoSurface extends ModuleSurface
  constructor: ( @module, index )->
    super @.module, index

    videoSrc = @.module.videoSrc()
    #@.domElement = new DOMElement @, {
      #properties:
        #height: "100%"

      #content: "<video src='#{videoSrc}' class='inherit' controls autoplay> Your browser does not support this video tag, please logout and use another browser </video>"
      
    #}
