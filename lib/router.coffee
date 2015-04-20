Router.map ()->
  
  ###
  # Home
  # Displays all chapters in curriculum
  ###
  this.route '/', {
    path: '/'
    name: 'home'
    template: 'home'
    yieldTemplates: {
      'footer': {to:"footer"}
    }
    layoutTemplate: 'layout'
    data: ()->
      if this.ready()
        curr = Curriculum.findOne({})
        if curr
          Session.set "current chapter", null
          Session.set "current lesson", null
          Session.set "current module index", null
          Session.set "module sequence", null
          Session.set "sections map", {}
          Session.set "current sections", null
          chapters =  curr.getLessonDocuments()
          Session.set "chapters sequence", chapters
          return {chapters: chapters}
  }

  ###
  # Logout
  ###
  this.route '/logout', {
    path: '/logout'
    name: 'logout'
    where: 'server'
  }

  ###
  # Module Sequence
  ###
  this.route '/modules/:nh_id/:index', {
    path: '/modules/:nh_id/:index'
    layoutTemplate: 'layout'
    name: 'ModulesSequence'
    template: "Module"
    yieldTemplates: {
      'moduleFooter': {to:"footer"}
    }
    data: () ->
      if this.ready()
        console.log "going to the module"
        if !Session.get "modules sequence"
          lesson = Lessons.findOne {nh_id: this.params.nh_id}
          Session.set "current lesson", lesson
          modules = lesson.getModulesSequence()
          Session.set "modules sequence", modules
          Session.set "current module index", parseInt this.params.index
        modules = Session.get "modules sequence"
        nh_id = modules[this.params.index].nh_id
        moduleDoc = Modules.findOne {nh_id: nh_id}
        console.log "this is the module DoC", moduleDoc
        Session.set "current template type", moduleDoc.type
        return {module: moduleDoc}
        
  }


  ###
  # Refresh the content
  ###
  this.route '/refreshcontent', {
    path: '/refreshcontent'
    data: ()->
      Meteor.call "refreshContent", ()->
        console.log "Yey called refresh"
  }



