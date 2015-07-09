###
# MODULES SEQUENCE HELPERS
###

Template.module.helpers

  rearrangedModules: ()->
    modules = (module for module in @.modules)
    firstModule = modules[0]
    rearrangedModules = modules.splice(1)
    rearrangedModules.push {_id: "dummyModule", type:"dummy"}
    rearrangedModules.push firstModule
    return rearrangedModules

  dummyModule: ()->
    return @.type == "dummy"

  currentModule: ()->
    if @
      return @.modules[Session.get "current module index"]

Template.module.rendered =  ()=>
  @.moduleSurfaces = []
  #fview.node._object.hide()
  hidden =  nextBtnShouldHide()
  Session.set "next button is hidden", hidden
  #lightbox controller
  lightbox = FView.byId "lightbox"
  eventInput = new EventHandler()
  EventHandler.setInputHandler lightbox, eventInput
  
  #get the next btn's view and event handler
  nextBtnFview = FView.byId "footer"
  nextBtnSurface = nextBtnFview.view or nextBtnFview.surface
  nextBtnEventOutput = nextBtnSurface._eventOutput

  #subscribe the lightbox to the next btn footer's events
  eventInput.subscribe nextBtnEventOutput

  modules = Template.currentData().modules
  @.moduleView = new ModuleView modules

  eventInput.on "showModule", (index)=>
    @.moduleView.show index

  #create the surfaces
  @.moduleView.show 0

class ModuleView
  constructor: (@modules)->
    @.lightbox = FView.byId("lightbox").node._object

  show: (index)=>
    surface = new SurfaceFactory(@.modules[index]).getSurface()
    #surface = moduleView.buildModuleSurface()
    @.lightbox.show surface

class ModuleSurface
  constructor: (@template, @module)->
    @.size = [600, 400]
    @.html = @.templateToHtml()
    @.surface = @.buildSurface()
    @.sync = new GenericSync(['mouse','touch'])

    #pipe all touch and mouse events to the surface
    @.sync.pipe @.surface
    console.log @.surface
    @.surface.pipe @.sync
    @.surface._eventOutput.subscribe @.sync
    @.registerFamousEvents()

  registerFamousEvents: ()=>
    @.surface.on "click", (event)->
      console.log "SURFACE was clicked, no sync"
    @.sync.on "click", (event)->
      console.log "Multiple choice is click"
    @.surface.on "end", (event)->
      console.log "Multiple choice is end"

    @.surface.on "update", (event)->
      console.log "Multiple choice is updated"

    @.sync.on "start", (event)->
      console.log "Multiple choice is clicked/touched"
      console.log event
      if $(event.target).hasClass ".image-choice"
        console.log "This was an image choice class"
  getSurface: ()=>
    return @.surface

  buildSurface: ()=>
    return new Surface {
      size: @.size
      content: @.html
    }

  templateToHtml: ()=>
    return Blaze.toHTMLWithData @.template, @.module

class SurfaceFactory
  constructor: (@module)->
    @.surfaceView = @.getModuleSurface module

  getSurface: ()=>
    return @.surfaceView.getSurface()
  
  getSurfaceView: ()=>
    return @.surfaceView

  getModuleSurface: ()=>
    type = @.module.type

    switch type
      when "SLIDE" then return new SlideSurface @.module
      when "MULTIPLE_CHOICE" then return new MultipleChoiceSurface @.module
      when "BINARY" then return new BinarySurface @.module
      when "VIDEO" then return new VideoSurface @.module
      when "SCENARIO" then return new ScenarioSurface @.module
      else console.log "module type is not within the module types allowed"
    

  #buildModuleSurface: ()=>
    #console.log @.module
    #type = @.module.type
    #html = ""

    #@.toHtml = (template, data)=>
      #@.html =  Blaze.toHTMLWithData(template, data)

    #switch type
      #when "SLIDE" then @.toHtml Template.slideModule, @.module
      #when "MULTIPLE_CHOICE" then @.toHtml(Template.multipleChoiceModule, @.module)
      #when "BINARY" then @.toHtml(Template.binaryChoiceModule, @.module)
      #when "VIDEO" then @.toHtml(Template.videoModule, @.module)
      #when "SCENARIO" then @.toHtml(Template.scenarioModule, @.module)
      #else console.log "module type is not within the module types allowed"

    #surface = new Surface {
      #content: @.html
      #size: [400,400]
    #}

    #surface.on {
      #"click": (one, two)->
        #console.log "TEMPLATE CLICKED"
        #console.log one
        #console.log two

      #"mouseover": (one,two)=>
        #console.log "MOUSEOVER"
      #}

    #return surface
      
###
# Slide Surface
###
class @SlideSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.slideModule, @.module)

###
# Binary Choice Surface
###
class @BinarySurface extends ModuleSurface
  constructor: (@module)->
    super(Template.binaryChoiceModule, @.module)
    @.registerFamousEvents()

  registerFamousEvents: ()=>
    console.log "Synce"
    console.log @.sync
    @.sync.on "click", (event)->
      console.log "BinarySurface clicked!"
      console.log event
      if buttonDisabled event.target
        return
      else
        response = $(event.target).val()
        handleResponse response

###
# Multiple Choice Surface
###
class @MultipleChoiceSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.multipleChoiceModule, @.module)
    console.log "synce"
    console.log @.sync



###
# Scenario Surface
###
class @ScenarioSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.scenarioModule, @.module)

###
# Video Surface
###
class @VideoSurface extends ModuleSurface
  constructor: (@module)->
    super(Template.videoModule, @.module)
