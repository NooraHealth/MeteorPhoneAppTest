
###
# Slide Surface
###
class @SlideSurface extends ModuleSurface
  constructor: ->
    super( @.module , index )

    @.domElement = new DOMElement @, {
      content: "<p>I am slide choice</p>"
    }
