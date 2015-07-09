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

Template.module.rendered =  ()->
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

  #eventInput.on "showModule", (id)->
    #console.log "Showing the module"
    #surface = FView.byId id
    #lightbox.node._object.show surface


  #create the surfaces
  modules = Template.currentData().modules
  module = new ModuleView modules[0]
  surface = module.buildModuleSurface()
  console.log "ModuleTemplate surface"
  console.log surface
  lightbox.node._object.show surface

class ModuleView
  
  constructor: (@module)->

  buildModuleSurface: ()=>
    console.log @.module
    type = @.module.type
    html = ""

    toHtml = (template, data)=>
      @.html =  Blaze.toHTMLWithData(template, data)

    switch type
      when "SLIDE" then toHtml Template.slideModule, @.module
      when "MULTIPLE_CHOICE" then toHTML(Template.multipleChoiceModule, @.module)
      when "BINARY" then toHTML(Template.binaryChoiceModule, @.module)
      when "VIDEO" then toHTML(Template.videoModule, @.module)
      when "SCENARIO" then toHTML(Template.scenarioModule, @.module)
      else console.log "module type is not within the module types allowed"

    surface = new Surface {
      content: @.html
      size: [400,400]
    }

    return surface
      

