
###
# Slide Surface
###
class @SlideSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.slideModule, @.module)
