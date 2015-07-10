
class @ModuleSurface
  constructor: (@template, @module)->
    console.log "Iam a amodule surface and her is my module"
    console.log @.module
    @.size = [600, 400]
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    #@.mouseSync = new MSync()
    #@.sync = new GenericSync(['scroll', 'touch'])
    ##@.sync.addSync 'touch'
    #console.log @.sync
    @.surface = @.buildSurface()
    #@.mouseSync = new MSync()
    #@.sync = new GenericSync(['scroll', 'touch'])
    #

    #@.surface.pipe(@.mouseSync)
    ##pipe all touch and mouse events to the surface
    #@.surface.pipe @.sync
    #@.surface.pipe @.mouseSync
    @.registerFamousEvents()

  getModule: ()=>
    return @.module

  handleClick: (event)=>
    console.log "Click Event!"

  handleInputUpdate: (event)=>
    console.log "Update Event!"

  handleInputEnd: (event)=>
    console.log "End Event!"

  registerFamousEvents: ()=>
    @.surface.on "click", (event)=>
      @.handleClick(event)
    #@.mouseSync.on "start", (event)=>
      #@.handleClick event
    #@.mouseSync.on "end", (event)=>
      #@.handleInputEnd event
    #@.mouseSync.on "update", (event)=>
      #@.handleInputUpdate event

    #@.sync.on "start", (event)=>
      #@.handleClick event
    #@.sync.on "end", (event)=>
      #@.handleInputEnd event
    #@.sync.on "update", (event)=>
      #@.handleInputUpdate event

  getSurface: ()=>
    return @.surface

  buildSurface: ()=>
    return new Surface {
      size: @.size
      content: @.html
    }

  templateToHtml: ()=>
    return Blaze.toHTMLWithData @.template, @.module

