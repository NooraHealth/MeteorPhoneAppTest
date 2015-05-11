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
      if this.ready() and Meteor.user()
        curr = Curriculum.findOne({condition: Meteor.user().profile.condition})
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
  this.route '/modules/:nh_id', {
    path: '/modules/:nh_id'
    layoutTemplate: 'layout'
    name: 'ModulesSequence'
    template: "module"
    yieldTemplates: {
      'moduleFooter': {to:"footer"}
    }
    data: () ->
      if this.ready()
        lesson = Lessons.findOne {nh_id: this.params.nh_id}
        Session.set "current lesson", lesson
        modules = lesson.getModulesSequence()
        Session.set "modules sequence", modules
        Session.set "current module index",0
        Session.set "correctly answered", []
        Session.set "incorrectly answered", []
        Session.set "next button is hidden", false
        return {modules:  modules  }
        
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


  this.route '/createCurriculum', {
    path: '/createCurriculum'
  }

