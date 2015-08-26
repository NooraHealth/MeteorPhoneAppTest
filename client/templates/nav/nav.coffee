Template.nav.helpers

 moduleDocs: ()->
  console.log "Current data in the nav"
  obj = Session.get "modules sequence"
  if !obj
    return ""
  console.log obj
  getModuleDoc = (module)->
    return Modules.findOne({_id: module._id})

  modules = ( getModuleDoc(module) for module in obj when module != null)
  return modules
