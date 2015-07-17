Template.nav.helpers
 logo: ()->
   return MEDIA_URL + "VascularContent/Images/NooraLogo.png"

 moduleDocs: ()->
  #console.log Template.currentData()
  #modules = Template.currentData().modules
  obj = Session.get "modules sequence"
  if !obj
    return ""
  console.log obj
  getModuleDoc = (module)->
    return Modules.findOne({_id: module._id})

  modules = ( getModuleDoc(module) for module in obj when module != null)
  return modules
  
  #console.log modules
  #createAudioTag = (module)->
    #src = module.audioSrc()
    #id = module._id
    #return "<audio id='toplay#{id}' src="+src+" preload='auto' autoplay></audio>"

  #audioTags = ( createAudioTag(module) for module in modules )
  #str= ""
  #for audio in audioTags
    ##$("nav").append audioTags 
    #str += audio
  #console.log str
  #return str
Template.nav.onRendered ()->
  fview = FView.from this
  surface = fview.view or fview.surface
  surface.setProperties {zIndex: 12}
