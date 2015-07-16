
#class @BaseSurface
  #constructor: (@surface)->
    #@.registerFamousEvents()
    
  #handleClick: (event)=>

  #handleInputUpdate: (event)=>

  #handleInputEnd: (event)=>

  #registerFamousEvents: ()=>
    #@.surface.on "click", (event)=>
      #@.handleClick(event)
    ##@.mouseSync.on "start", (event)=>
      ##@.handleClick event
    ##@.mouseSync.on "end", (event)=>
      ##@.handleInputEnd event
    ##@.mouseSync.on "update", (event)=>
      ##@.handleInputUpdate event

    ##@.sync.on "start", (event)=>
      ##@.handleClick event
    ##@.sync.on "end", (event)=>
      ##@.handleInputEnd event
    ##@.sync.on "update", (event)=>
      ##@.handleInputUpdate event

  #getSurface: ()=>
    #return @.surface
